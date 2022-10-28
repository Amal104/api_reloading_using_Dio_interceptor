import 'package:api_reloading/screens/Demo.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key});

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  void initState() {
    Connectivity().onConnectivityChanged.listen((event) {
      Get.off(()=>const Demo());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/error.jpg',
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 80.0,
          ),
          const Text(
            'Waiting for connection....',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14.0,
            ),
          )
        ],
      )),
    );
  }
}
