import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String postTile = 'Waiting...';
  bool isLoading = false;
  Dio dio = Dio();
  Connectivity connectivity = Connectivity();

  int randomNumber() {
    var random = Random();
    int min = 0;
    int max = 100;
    int result = min + random.nextInt(max - min);
    return result;
  }

  getData() async {
    try {
      final response = await dio
          .get('https://jsonplaceholder.typicode.com/posts');
      setState(() {
        postTile = response.data[randomNumber()]['body'];
        isLoading = false;
      });
    } catch (e) {
      return e;
    }
  }

  // @override
  // void initState() {
  //   connectivity.onConnectivityChanged.listen(
  //     (result) {
  //       getData();
  //     },
  //   );
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                textAlign: TextAlign.center,
                postTile,
                style: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              ElevatedButton(onPressed: () => getData(), child:const Text('Load more Data'))
            ],
          ),
        ),
      ),
    );
  }
}
