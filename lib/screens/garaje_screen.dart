import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gas_fuel/screens/vehiculo_screen.dart';
import 'package:sizer/sizer.dart';

class GarajeScreen extends StatefulWidget {
  const GarajeScreen({Key? key}) : super(key: key);

  @override
  State<GarajeScreen> createState() => _GarajeScreenState();
}

class _GarajeScreenState extends State<GarajeScreen> {
  String name = '';
  List<dynamic> cars = [];
  List<dynamic> carNames = [];
  List<dynamic> images = [];

  Future getData() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final docRef = users.doc("37ULJDbWzHceIHFKZWn2");
    await docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          name = data['name'];
          cars = data['cars'];
        });
      },
      onError: (e) => print("Error getting document: $e"),
    ).then((value) {
      for (var i = 0; i < cars.length; i++) {
        getCars(cars[i]);
      }
    });
  }

  Future getCars(String index) async {
    CollectionReference carsdb = FirebaseFirestore.instance.collection('cars');
    final docRef = carsdb.doc(index);
    docRef.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      setState(() {
        carNames.add(data['name']);
        images.add(data['image']);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // Llamamos a getData al inicio del proceso de construcción del widget
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Coches'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 49, 49, 49),
        elevation: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 49, 49, 49),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 100.w,
            height: 100.h,
            child: SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  height: 30.h,
                  width: 90.w,
                  child: Stack(children: [
                    Image(
                      image: const AssetImage("assets/fondoGaraje.png"),
                      fit: BoxFit.contain,
                      height: 100.h,
                      width: 100.w,
                    ),
                    Positioned(
                      bottom: 2.h,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const VehiculoScreen(id: "1")),
                          );
                        },
                        child: Image(
                          image: const NetworkImage(
                              "https://media-assets.mazda.eu/image/upload/c_fill,w_768,q_auto,f_auto/mazdaes/globalassets/offers/clearcuts/mx-5-rf-ipm.png?rnd=4affaa"),
                          height: 10.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                        left: 0,
                        bottom: 2.h,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const VehiculoScreen(id: "2")),
                            );
                          },
                          child: Image(
                            height: 10.h,
                            fit: BoxFit.contain,
                            image: const NetworkImage(
                                "https://kong-proxy-aws.toyota-europe.com/l1-images/resize/ccis/680x680/zip/es/product-token/e8997f7d-a7c3-479c-8b1a-742392a1d525/vehicle/9e5993e6-7560-4f36-932d-937e63abf31e/padding/50,50,50,50/image-quality/70/day-exterior-4_212.png"),
                          ),
                        ))
                  ]),
                ),
                SizedBox(
                  height: 60.h,
                  width: 90.w,
                  child: ListView.builder(
                      itemCount: cars.length, // número de elementos en la lista
                      itemBuilder: (context, index) {
                        return coche(context,
                            name: carNames[index],
                            image: images[index],
                            id: cars[index]);
                      }),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Container coche(context,
      {required String name, required String image, required String id}) {
    return Container(
      height: 28.h,
      width: 90.w,
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 38, 38, 38),
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VehiculoScreen(id: id)),
          );
        },
        child: Center(
          child: SizedBox(
            width: 80.w,
            height: 25.h,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                  Image(
                    image: NetworkImage(image),
                    width: 100.w,
                    height: 20.h,
                    fit: BoxFit.contain,
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
