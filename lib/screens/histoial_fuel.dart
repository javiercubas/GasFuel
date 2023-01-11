// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';

class HistorialFuelScreen extends StatelessWidget {
  const HistorialFuelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir repostaje'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 49, 49, 49),
        elevation: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 49, 49, 49),
      body: Center(
        child: Column(
          children: [
            Text(
              "Mazda MX-5",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
              ),
            ),
            Image(
              image: const NetworkImage(
                  "https://media-assets.mazda.eu/image/upload/c_fill,w_768,q_auto,f_auto/mazdaes/globalassets/offers/clearcuts/mx-5-rf-ipm.png?rnd=4affaa"),
              height: 25.h,
              width: 80.w,
              fit: BoxFit.contain,
            ),
            Text(
              "Resumen",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gap(1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                circleInfo(infoText: "7549 L"),
                circleInfo(infoText: "467 €"),
              ],
            ),
            Gap(3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                data(text: "Mes"),
                data(text: "Litros"),
                data(text: "Distancia"),
                data(text: "Gasto"),
                data(text: "Info"),
              ],
            ),
            Gap(2.h),
            SizedBox(
              width: 100.w,
              height: 40.h,
              child: SingleChildScrollView(
                  child: Column(children: [
                monthlyRegis(
                  context,
                  color: const Color.fromARGB(
                      255, 38, 38, 38), //const Color.fromARGB(255, 49, 49, 49),
                  mes: "Enero",
                  litros: "130 L",
                  km: "4765 km",
                  precio: "218 €",
                ),
                monthlyRegis(
                  context,
                  color: const Color.fromARGB(255, 49, 49, 49),
                  mes: "Enero",
                  litros: "130 L",
                  km: "4765 km",
                  precio: "218 €",
                ),
                monthlyRegis(
                  context,
                  color: const Color.fromARGB(255, 38, 38, 38),
                  mes: "Enero",
                  litros: "130 L",
                  km: "4765 km",
                  precio: "218 €",
                ),
                monthlyRegis(
                  context,
                  color: const Color.fromARGB(255, 49, 49, 49),
                  mes: "Enero",
                  litros: "130 L",
                  km: "4765 km",
                  precio: "218 €",
                ),
                monthlyRegis(
                  context,
                  color: const Color.fromARGB(255, 38, 38, 38),
                  mes: "Enero",
                  litros: "130 L",
                  km: "4765 km",
                  precio: "218 €",
                ),
                monthlyRegis(
                  context,
                  color: const Color.fromARGB(255, 49, 49, 49),
                  mes: "Enero",
                  litros: "130 L",
                  km: "4765 km",
                  precio: "218 €",
                ),
                monthlyRegis(
                  context,
                  color: const Color.fromARGB(255, 38, 38, 38),
                  mes: "Enero",
                  litros: "130 L",
                  km: "4765 km",
                  precio: "218 €",
                ),
                monthlyRegis(
                  context,
                  color: const Color.fromARGB(255, 49, 49, 49),
                  mes: "Enero",
                  litros: "130 L",
                  km: "4765 km",
                  precio: "218 €",
                ),
              ])),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector monthlyRegis(BuildContext context,
      {required String mes,
      required Color color,
      required String litros,
      required String km,
      required String precio}) {
    void _showDialog() {
      showModalBottomSheet(
        context: context,
        elevation: 5,
        backgroundColor: const Color.fromARGB(255, 38, 38, 38),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return const Modal();
        },
      );
    }

    return GestureDetector(
      onTap: () {
        _showDialog();
      },
      child: Container(
        width: 100.w,
        height: 6.5.h,
        color: color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            data(text: mes),
            data(text: litros),
            data(text: km),
            data(text: precio),
            SvgPicture.asset("assets/arrowVector.svg", height: 3.5.h),
          ],
        ),
      ),
    );
  }

  Text data({required String text}) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 13.sp,
      ),
    );
  }

  Container circleInfo({required String infoText}) {
    return Container(
      width: 80,
      height: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 38, 38, 38),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white, width: 5),
      ),
      child: Text(
        infoText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13.sp,
        ),
      ),
    );
  }
}

class Modal extends StatefulWidget {
  const Modal({Key? key}) : super(key: key);

  @override
  _ModalState createState() => _ModalState();
}

class _ModalState extends State<Modal> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Gap(2.h),
            SizedBox(
              width: 90.w,
              height: 3.h,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    child: Text(
                      "RESUMEN DEL MES",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins"),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Positioned(
                      right: 0, child: Icon(Icons.close, color: Colors.grey))
                ],
              ),
            ),
            Gap(1.h),
          ],
        ),
      ),
    );
  }
}
