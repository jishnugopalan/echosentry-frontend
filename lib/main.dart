import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

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
      home: IntroSlider()
    );
  }
}


