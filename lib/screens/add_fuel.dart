import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';

class AddFuelScreen extends StatelessWidget {
  const AddFuelScreen({Key? key}) : super(key: key);

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
        child: SingleChildScrollView(
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
              addElements(typeData: "Km anteriores"),
              addElements(typeData: "Km actuales"),
              addElements(typeData: "Km recorridos"),
              addElements(typeData: "L repostados"),
              addElements(typeData: "Precio total del depósito"),
              addElements(typeData: "€/L"),
              Gap(4.h),
              saveButton(),
              Gap(4.h),
            ],
          ),
        ),
      ),
    );
  }

  Container saveButton() {
    return Container(
      width: 50.w,
      height: 5.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 38, 38, 38),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "GUARDAR",
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  SizedBox addElements({required String typeData}) {
    return SizedBox(
      width: 90.w,
      height: 10.h,
      child: Column(
        children: [
          SizedBox(
            width: 90.w,
            height: 10.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  typeData,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  width: 90.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 38, 38, 38),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
