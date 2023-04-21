import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:echosentry/customer/customermenu.dart';
import 'package:echosentry/customer/viewconnectedland.dart';
import 'package:echosentry/landholder/landmenu.dart';
import 'package:echosentry/services/land_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'land.dart';

class Land {
  final String city;
  final int squareFeet;
  final String image;

  Land({required this.city, required this.squareFeet, required this.image});

  factory Land.fromJson(Map<String, dynamic> json) {
    return Land(
      city: json['land']['landcity'],
      squareFeet: json['land']['squarefeet'],
      image: json['land']['landphoto'],
    );
  }

  Widget getLandTile() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.memory(
              base64Decode(image.split(',')[1]),
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  city,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  '${squareFeet.toString()} square feet',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ConncetedLands extends StatefulWidget {
  @override
  _ConncetedLandsState createState() => _ConncetedLandsState();
}

class _ConncetedLandsState extends State<ConncetedLands> {
  late final Response response;
  LandService service=LandService();
  late List<Land> lands=[];
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    fetchLands();
  }

  Future<void> fetchLands() async {
    Map<String, String> allValues = await storage.readAll();
    String? userid = allValues["userid"];
    response = await service.viewConnectedLandByCustomer(userid!);
    print(response);

    if (response.statusCode == 201) {
      final jsonList = response.data as List;
      lands = jsonList.map((json) => Land.fromJson(json)).toList();
      setState(() {});
    } else {
      throw Exception('Failed to load lands');
    }
  }
  getLandDetails(index){
    String landid="";
    final jsonList = response.data as List;
    landid=jsonList[index]["land"]["_id"];
    print(landid);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ViewConncetedLand(landid: landid),
      ),
    );


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connected Lands'),
      ),
      drawer: CustomerMenu(),
      body: lands == null
          ? Center(
        child: CircularProgressIndicator(),
      )
          : GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        itemCount: lands.length,
        itemBuilder: (context, index) {
          final land = lands[index];
          return GestureDetector(
            onTap: (){
              getLandDetails(index);
            },
            child: land.getLandTile(),
          );
        },
      ),
    );
  }
}
