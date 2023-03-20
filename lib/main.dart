import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ECHOSENTRY',
      theme: ThemeData(

        primaryColor: Colors.green[800],
        primarySwatch: Colors.green,

      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

