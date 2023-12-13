import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late var response; // Variable to hold the fetched emails

  @override
  void initState() {
    apiCall(); // Fetch data on widget initialization
    super.initState();
  }

  Future<void> apiCall() async {
    var apiResponse = await http.get(Uri.parse('https://reqres.in/api/users/'));

    if (apiResponse.statusCode == 200) {
      setState(() {
        Map<String, dynamic> data = json.decode(apiResponse.body);

        List<dynamic> users = data['data'];
        List<String> emails =
            users.map((user) => user['email'].toString()).toList();

        response = emails.join('\n'); // Join emails with line breaks
        print(response);
      });
    } else {
      print('Failed to fetch data: ${apiResponse.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API DEMO'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          height: 250,
          width: 320,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: response != null // Display fetched emails
                ? Text(
                    response,
                    textAlign: TextAlign.center,
                  )
                : CircularProgressIndicator(), // Show loading indicator
          ),
        ),
      ),
    );
  }
}
