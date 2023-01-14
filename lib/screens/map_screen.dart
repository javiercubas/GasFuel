import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position _position = Position(
    latitude: 0,
    longitude: 0,
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
    timestamp: DateTime.now(),
    isMocked: false,
  );
  LatLng _center = LatLng(0, 0);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([_determinePosition(), _getGasolinerasMarkers()]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Position position = snapshot.data[0] as Position;
            _center = LatLng(position.latitude, position.longitude);
            final markers = snapshot.data[1] as List<Marker>;
            return _buildMap(_center, markers);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _buildMap(LatLng center, List<Marker> markers) {
    return FlutterMap(
      options: MapOptions(
        center: center,
        zoom: 15,
        maxZoom: 18,
      ),
      nonRotatedChildren: [
        Stack(
          children: [
            Positioned(
              bottom: 15.h,
              right: 4.w,
              child: GestureDetector(
                onTap: () {
                  _centerMapOnUser();
                },
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 49, 49, 49),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.my_location,
                    color: Colors.white,
                    size: 10.0.w,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: 100.w,
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                height: 4.h,
                color: const Color.fromARGB(255, 38, 38, 38),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("© OpenStreetMap",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 12.sp)),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 3.9.h,
              width: 100.w,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 49, 49, 49),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image(
                        image: const NetworkImage(
                            "https://cdn.cookielaw.org/logos/7ac73671-dcc7-49ac-8bc8-62378218ce5c/2746fc61-d6e4-4a21-aaf4-b38c2ebe618b/717a9471-1ce2-4ec9-95e5-c3cb8058b16d/Repsol-Logo.wine.png"),
                        width: 25.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Repsol",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          Text("1.23€",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("65,73€",
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          Text("L-D: 06:00-22:00",
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(1.5.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Icon(
                              Icons.directions,
                              color: Colors.black,
                              size: 8.w,
                            ),
                          ),
                          Text("1,2km",
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      )
                    ]),
              ),
            )
          ],
        ),
      ],
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            maxClusterRadius: 90,
            size: const Size(40, 40),
            anchor: AnchorPos.align(AnchorAlign.center),
            fitBoundsOptions: const FitBoundsOptions(
              padding: EdgeInsets.all(50),
              maxZoom: 15,
            ),
            markers: markers,
            builder: (context, markers) {
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green[800]),
                child: Center(
                  child: Text(
                    markers.length.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 45.0,
              height: 45.0,
              point: center,
              builder: (ctx) => Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://media-assets.mazda.eu/image/upload/c_fill,w_768,q_auto,f_auto/mazdaes/globalassets/offers/clearcuts/mx-5-rf-ipm.png?rnd=4affaa"))),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<List> _getGasolineras() async {
    const url =
        "https://sedeaplicaciones.minetur.gob.es/ServiciosRESTCarburantes/PreciosCarburantes/EstacionesTerrestres/";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final gasolinerasList = jsonData["ListaEESSPrecio"];
      return gasolinerasList;
    } else {
      print("Error al obtener la respuesta");
      return Future.error("Error al obtener la respuesta");
    }
  }

  Future<List<Marker>> _getGasolinerasMarkers() async {
    final gasolineras = await _getGasolineras();
    List<Marker> markers = [];
    Marker marker = Marker(builder: (ctx) => Container(), point: LatLng(0, 0));
    double mediaDiesel = 0.0;

// obtener la localización actual del usuario
    Position position = await Geolocator.getCurrentPosition();
    LatLng currentLocation = LatLng(position.latitude, position.longitude);

// filtrar gasolineras con precio Gasoleo A vacío
    gasolineras
        .removeWhere((gasolinera) => gasolinera["Precio Gasoleo A"] == "");

// ordenar la lista de gasolineras por precio de Gasoleo A y distancia a la localización actual
    gasolineras.sort((a, b) {
      double aLat = double.parse(a["Latitud"].replaceAll(',', '.'));
      double aLng = double.parse(a["Longitud (WGS84)"].replaceAll(',', '.'));
      double bLat = double.parse(b["Latitud"].replaceAll(',', '.'));
      double bLng = double.parse(b["Longitud (WGS84)"].replaceAll(',', '.'));
      double aDist = Geolocator.distanceBetween(
          currentLocation.latitude, currentLocation.longitude, aLat, aLng);
      double bDist = Geolocator.distanceBetween(
          currentLocation.latitude, currentLocation.longitude, bLat, bLng);
      if (a["Precio Gasoleo A"] == b["Precio Gasoleo A"]) {
        return aDist.compareTo(bDist);
      } else {
        return a["Precio Gasoleo A"].compareTo(b["Precio Gasoleo A"]);
      }
    });

// obtener solo el 10% de las gasolineras mas baratas y cercanas a la localización actual
    int numGasolineras = (gasolineras.length * 0.15).floor();
    List gasolinerasBaratas = gasolineras.sublist(0, numGasolineras);
    List gasolinerasCaras = gasolineras.sublist(numGasolineras);

// calcular la media de precio de Gasoleo A
    double sumaDiesel = 0.0;
    for (var gasolinera in gasolineras) {
      sumaDiesel +=
          double.parse(gasolinera["Precio Gasoleo A"].replaceAll(',', '.'));
      mediaDiesel = sumaDiesel / gasolineras.length;
    }

    for (var gasolinera in gasolinerasBaratas) {
      final latitud = double.parse(gasolinera["Latitud"].replaceAll(',', '.'));
      final longitud =
          double.parse(gasolinera["Longitud (WGS84)"].replaceAll(',', '.'));

      marker = Marker(
        width: 75.0,
        height: 75.0,
        point: LatLng(latitud, longitud),
        builder: (ctx) => Container(
          child: Stack(
            children: [
              Positioned(
                  child: SvgPicture.asset("assets/marker.svg",
                      color: Colors.green[800], width: 75)),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                top: 15,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${(mediaDiesel * 58.5 - double.parse(gasolinera["Precio Gasoleo A"].replaceAll(",", ".")) * 58.5).toStringAsFixed(2).replaceAll(".", ",")}€",
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const Gap(3),
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(gasolinera["Rótulo"]
                                          .toLowerCase() ==
                                      "ballenoil"
                                  ? "https://pbs.twimg.com/profile_images/1067104044915851264/LzTXq24v_400x400.jpg"
                                  : ""),
                            ),
                            borderRadius: BorderRadius.circular(100)),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      );
      markers.add(marker);
    }

    for (var gasolinera in gasolinerasCaras) {
      final latitud = double.parse(gasolinera["Latitud"].replaceAll(',', '.'));
      final longitud =
          double.parse(gasolinera["Longitud (WGS84)"].replaceAll(',', '.'));

      marker = Marker(
        width: 75.0,
        height: 75.0,
        point: LatLng(latitud, longitud),
        builder: (ctx) => Container(
          child: Stack(
            children: [
              Positioned(
                  child: SvgPicture.asset("assets/marker.svg",
                      color: Colors.black, width: 75)),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                top: 15,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${(mediaDiesel * 58.5 - double.parse(gasolinera["Precio Gasoleo A"].replaceAll(",", ".")) * 58.5).toStringAsFixed(2).replaceAll(".", ",")}€",
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const Gap(3),
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(gasolinera["Rótulo"]
                                          .toLowerCase() ==
                                      "ballenoil"
                                  ? "https://pbs.twimg.com/profile_images/1067104044915851264/LzTXq24v_400x400.jpg"
                                  : ""),
                            ),
                            borderRadius: BorderRadius.circular(100)),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      );
      markers.add(marker);
    }

    return markers;
  }

  void _centerMapOnUser() {
    setState(() {
      _center = LatLng(_position.latitude, _position.longitude);
    });
  }
}
