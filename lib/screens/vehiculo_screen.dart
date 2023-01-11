import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gap/gap.dart';
import 'package:gas_fuel/screens/add_fuel.dart';
import 'package:gas_fuel/screens/garaje_screen.dart';
import 'package:gas_fuel/screens/map_screen.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class VehiculoScreen extends StatefulWidget {
  const VehiculoScreen({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<VehiculoScreen> createState() => _VehiculoScreenState();
}

class _VehiculoScreenState extends State<VehiculoScreen> {
  int _index = 0;
  String name = '';
  String value = '';
  String image = '';
  String etiqueta = '';
  String kilometros = '';
  String combustible = '';

  Future getCars(String index) async {
    CollectionReference carsdb = FirebaseFirestore.instance.collection('cars');
    final docRef = carsdb.doc(index);
    docRef.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      setState(() {
        name = data['name'];
        value = data['model'];
        image = data['image'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCars(widget.id);
    setState(() {
      _id = _prefs.then((SharedPreferences prefs) {
        return (prefs.getString('id') ?? widget.id);
      });
    });
  }

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _id;
  Future setID() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      _id = prefs.setString('id', widget.id).then((bool success) {
        return widget.id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Offstage(
          offstage: _index != 0,
          child: TickerMode(
            enabled: _index == 0,
            child: body(context),
          ),
        ),
        Offstage(
          offstage: _index != 1,
          child: TickerMode(
            enabled: _index == 1,
            child: const MapScreen(),
          ),
        ),
        Offstage(
          offstage: _index != 2,
          child: TickerMode(
            enabled: _index == 2,
            child: const Center(
              child: Text("Favoritos"),
            ),
          ),
        ),
      ]),
      backgroundColor: const Color.fromARGB(255, 49, 49, 49),
      bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 38, 38, 38),
          currentIndex: _index,
          onTap: (index) {
            setState(() {
              _index = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Image.asset("assets/home.png", height: 4.h),
                label: "Inicio"),
            BottomNavigationBarItem(
                icon: Image.asset("assets/mapMenu.png", height: 4.h),
                label: "Mapa"),
            BottomNavigationBarItem(
                icon: Image.asset("assets/account.png", height: 4.h),
                label: "Cuenta"),
          ]),
    );
  }

  SafeArea body(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SizedBox(
          width: 85.w,
          height: 85.h,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name,
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900)),
                          Text(value,
                              style: TextStyle(
                                  fontSize: 14.sp, color: Colors.white)),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const GarajeScreen()),
                          );
                        },
                        child: Image(
                          image: const AssetImage("assets/garaje.png"),
                          height: 4.h,
                        ),
                      )
                    ]),
                Image(
                  image: NetworkImage(image),
                  height: 25.h,
                  width: 80.w,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: 8.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      section(name: "Kilómetros", value: kilometros),
                      section(name: "Combustible", value: combustible),
                      section(name: "Etiqueta", value: etiqueta),
                    ],
                  ),
                ),
                Gap(4.h),
                SizedBox(
                  width: 90.w,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buttons(
                          image: "assets/repostaje.png",
                          text: "Añadir Repostaje",
                          width: 40.w,
                          screen: const AddFuelScreen(),
                        ),
                        buttons(
                          image: "assets/historial.png",
                          text: "Historial Repostajes",
                          width: 40.w,
                          screen: const AddFuelScreen(),
                        ),
                      ]),
                ),
                Gap(3.h),
                buttons(
                  image: "assets/mapaIcon.png",
                  text: "Mapa de precios de gasolina",
                  width: 90.w,
                  screen: const AddFuelScreen(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column section({required String name, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name, style: TextStyle(fontSize: 16.sp, color: Colors.white)),
        Text(value, style: TextStyle(fontSize: 12.sp, color: Colors.white)),
      ],
    );
  }

  Container buttons(
      {required String image,
      required String text,
      required double width,
      required screen}) {
    return Container(
        width: width,
        height: 40.w,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 38, 38, 38),
          borderRadius: BorderRadius.circular(20),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen),
            );
          },
          child: SizedBox(
              height: 90.h,
              width: 90.w,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(text,
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Image(image: AssetImage(image), height: 20.w),
                  ])),
        ));
  }
}
