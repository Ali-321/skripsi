import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SC extends StatefulWidget {
  final Widget? child;
  const SC({super.key, this.child});

  @override
  State<SC> createState() => _SCState();
}

class _SCState extends State<SC> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.to(() => widget.child!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Top Up Game Online',
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 300,
            ),
            Text(
              'Lab Sistem Cerdas Teknik Informatika ',
              style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 2, 123, 178),
                  fontWeight: FontWeight.w500),
            ),
            Text(
              'Universitas Dian Nuswantoro',
              style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 7, 145, 208),
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
