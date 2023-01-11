import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([_determinePosition(), _getGasolinerasMarkers()]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Position position = snapshot.data[0] as Position;
            final markers = snapshot.data[1] as List<Marker>;
            return _buildMap(position.latitude, position.longitude, markers);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _buildMap(double latitude, double longitude, List<Marker> markers) {
    return FlutterMap(
      options: MapOptions(center: LatLng(latitude, longitude), zoom: 15),
      nonRotatedChildren: [
        Stack(
          children: [
            Positioned(
              bottom: 4.h,
              right: 4.w,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _determinePosition();
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.location_searching,
                    color: Colors.black,
                    size: 10.0.w,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(markers: markers)
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
    print(gasolineras[100]);
    for (var gasolinera in gasolineras) {
      final latitud = double.parse(gasolinera["Latitud"].replaceAll(',', '.'));
      final longitud =
          double.parse(gasolinera["Longitud (WGS84)"].replaceAll(',', '.'));

      final marker = Marker(
        width: 45.0,
        height: 45.0,
        point: LatLng(latitud, longitud),
        builder: (ctx) => Container(
          child: Icon(Icons.local_gas_station, color: Colors.red),
        ),
      );

      markers.add(marker);
    }
    return markers;
  }
}
