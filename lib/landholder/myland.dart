import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:echosentry/landholder/landmenu.dart';
import 'package:echosentry/landholder/viewland.dart';
import 'package:echosentry/services/land_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Land {
  final String city;
  final int squareFeet;
  final String image;

  Land({required this.city, required this.squareFeet, required this.image, required landid});

  factory Land.fromJson(Map<String, dynamic> json) {
    return Land(
      city: json['landcity'],
      squareFeet: json['squarefeet'],
      image: json['landphoto'],
      landid:json['_id']
    );
  }

  Widget getLandTile() {
    return ListTile(
      title: Text(city),
      subtitle: Text('${squareFeet.toString()} square feet'),
      leading: Image.memory(base64Decode(image.split(',')[1]),),
    );
  }
}

class MyLand extends StatefulWidget {
  @override
  _MyLandState createState() => _MyLandState();
}

class _MyLandState extends State<MyLand> {
  LandService service=LandService();
  late List<Land> lands=[];
  final storage = const FlutterSecureStorage();
  late final Response response;
  @override
  void initState() {
    super.initState();
    fetchLands();
  }

  Future<void> fetchLands() async {
    Map<String, String> allValues = await storage.readAll();
    String? userid=allValues["userid"];
     response = await service.viewLandByLandOwner(userid!);

    if (response.statusCode == 201) {
      final jsonList = response.data as List;
      lands = jsonList.map((json) => Land.fromJson(json)).toList();
      setState(() {});
    } else {
      // throw Exception('Failed to load lands');
      showError("Error in getting land details", "Error");
    }
  }
  showError(String content,String title){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {

                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lands'),

      ),
      drawer: LandMenu(),
      body: lands == null
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: lands.length,
        itemBuilder: (context, index) {
          final land = lands[index];
          return GestureDetector(
            child: land.getLandTile(),
            onTap: (){

             print(response.data[index]["_id"]);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LandViewPage(landId:response.data[index]["_id"],),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
