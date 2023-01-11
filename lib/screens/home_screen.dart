import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gas_fuel/screens/vehiculo_screen.dart';
import 'package:latlong2/latlong.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GasFUEL'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 38, 38, 38),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Mis trayectos",
                    style: TextStyle(color: Colors.black),
                  )),
              TextButton(
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const VehiculoScreen(id: "1")),
                      ),
                  child: const Text(
                    "Mis vehiculos",
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          ),
        ),
      ),
      body: Stack(children: [
        Offstage(
          offstage: _index != 0,
          child: TickerMode(
            enabled: _index == 0,
            child: home(),
          ),
        ),
        Offstage(
          offstage: _index != 1,
          child: TickerMode(enabled: _index == 1, child: Text("Hola Mundo")),
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 38, 38, 38),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _index,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Inicio",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Buscar"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Favoritos"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }

  Column home() {
    return Column(
      children: [
        Container(
            width: 100.w,
            height: 8.h,
            color: const Color.fromARGB(255, 49, 49, 49),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "Filtros",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Listado",
                    style: TextStyle(color: Colors.white),
                  )
                ])),
        SizedBox(
            width: 100.w,
            height: 75.h,
            child: Stack(
              children: [
                Positioned(
                  width: 100.w,
                  child: Image.asset("assets/mapa.png"),
                ),
              ],
            )),
      ],
    );
  }
}
