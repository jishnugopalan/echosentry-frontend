import 'package:echosentry/customer/customer_dashboard.dart';
import 'package:echosentry/customer/order.dart';
import 'package:echosentry/landholder/land_dashboard.dart';
import 'package:echosentry/login.dart';
import 'package:echosentry/registration/registration.dart';
import 'package:echosentry/shop/add_product.dart';
import 'package:echosentry/shop/shop_dashboard.dart';
import 'package:echosentry/shop/vieworders.dart';
import 'package:flutter/material.dart';


import 'introslider.dart';

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
      home: LoginPage(),
      routes: {
        '/login':(context)=>LoginPage(),
        '/registration':(context)=>RegistrationPage(),
        '/shopdashboard':(context)=>ShopDashboard(),
        '/intro':(context)=>IntroSlider(),
        '/add-product':(context)=>AddProducts(),
        '/customerdashboard':(context)=>CustomerDashboard(),
        '/landdashboard':(context)=>LandHolderDashboard(),
        '/order':(context)=>OrderPage(),
        '/viewordervendor':(context)=>ViewOrderVendor()

      },

    );
  }
}


