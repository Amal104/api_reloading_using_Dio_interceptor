import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:retry/retry.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String postTile = 'Press the button 👇';
  bool isLoading = false;

  getData() async {
    try {
      final response = await retry(
        // Make a GET request
        () => http
            .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'))
            .timeout(const Duration(seconds: 4)),
        // Retry on SocketException or TimeoutException
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      final data = json.decode(response.body);
      setState(() {
        postTile = data[0]['title'];
        isLoading = false;
      });
    } catch (e) {
      return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
              height: 50.0,
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                getData();
              },
              child: const Text('Request Data'),
            ),
          ],
        ),
      ),
    );
  }
}
