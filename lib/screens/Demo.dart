import 'dart:async';
import 'dart:math';
import 'package:api_reloading/screens/errorpage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../interceptors/Retry_interceptors.dart';

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  String postTile = 'Waiting...';
  String postTilee = 'Waiting...';
  bool isLoading = false;
  Dio dio = Dio();
  // int randomNumber() {
  //   var random = Random();

  //   int min = 0;

  //   int max = 100;

  //   int result = min + random.nextInt(max - min);
  //   return result;
  // }

  refresh() async {
    var data = await getDataa();
    setState(() {
      data;
    });
  }

  getData() async {
    try {
      final response =
          await dio.get('https://jsonplaceholder.typicode.com/posts');
      setState(() {
        postTile = response.data[0]['title'];
        isLoading = false;
      });
      await Future.delayed(const Duration(seconds: 2));
      getDataa();
    } catch (e) {
      return e;
    }
  }

  getDataa() async {
    try {
      final response =
          await dio.get('https://jsonplaceholder.typicode.com/posts').timeout(
                const Duration(seconds: 10),
                onTimeout: () => refresh(),
              );
      setState(() {
        postTilee = response.data[0]['body'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        postTilee = 'network error';
        isLoading = false;
      });
    }
  }

  // Future<void> checkConnectivity() async {
  //   var result = await Connectivity().checkConnectivity();
  //   if (result == ConnectivityResult.none) {
  //     Get.off(() => const ErrorPage());
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // checkConnectivity();
    dio.interceptors.add(
      RetryInterceptor(dio: dio),
    );
    getData();
    // getDataa();
    // setState(() {
    //   isLoading = true;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                const CircularProgressIndicator()
              else
                Text(
                  textAlign: TextAlign.center,
                  postTile,
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(
                height: 50,
                child: Divider(
                  color: Colors.black54,
                  thickness: 1,
                ),
              ),
              Text(
                textAlign: TextAlign.center,
                postTilee,
                style: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // const SizedBox(
              //   height: 50.0,
              // ),
              // ElevatedButton(
              //   onPressed: () async {
              //     // checkConnectivity();
              //     setState(() {
              //       isLoading = true;
              //     });
              //     getData();
              //   },
              //   child: const Text('Request Data'),
              // ),
              // const SizedBox(
              //   height: 50.0,
              // ),
              // ElevatedButton(
              //   onPressed: () async {
              //     // checkConnectivity();
              //     setState(() {
              //       isLoading = true;
              //     });
              //     getDataa();
              //   },
              //   child: const Text('Request Data 2'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
