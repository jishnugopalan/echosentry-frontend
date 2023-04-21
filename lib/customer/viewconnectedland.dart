import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:echosentry/customer/customermenu.dart';
import 'package:echosentry/services/land_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class ViewConncetedLand extends StatefulWidget {
  final String landid;

  ViewConncetedLand({required this.landid});

  @override
  _ViewConncetedLandState createState() => _ViewConncetedLandState();
}

class _ViewConncetedLandState extends State<ViewConncetedLand> {
  late Future<Map<String, dynamic>> _futureLand;
  LandService service=LandService();
  final storage = const FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    print(widget.landid);
    _futureLand = _fetchLandDetails();
  }

  Future<Map<String, dynamic>> _fetchLandDetails() async {
    final Response response =
    await service.viewLand(widget.landid);
    print(response);

    if (response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception('Failed to load land details');
    }
  }
  connectWithLandOwner() async {
    Map<String, String> allValues = await storage.readAll();
    String? userid=allValues["userid"];
    String? landid=widget.landid;
    var connect=jsonEncode({
      "user":userid,
      "land":landid
    });
    try{
      final Response res=await service.connectWithLandOwner(connect);
      print(res);
      showError("Connection send successfully", "Connection Send");
    }on DioError catch(e){
      if(e.response?.statusCode==405){
        showError("Connection already send", "Connected");
      }
      else{
        showError("Error in connection", "Error");
      }
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
        title: Text('Land Details'),
      ),
      drawer: CustomerMenu(),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _futureLand,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final land = snapshot.data!;
              return ListView(
                children: [
                  SizedBox(
                    height: 200,
                    child: Image.memory(
                      base64Decode(land['landphoto'].split(',')[1]),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text("Connect Now",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),textAlign: TextAlign.center,),
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Text(land["user"]["name"]+"\n"+land["user"]["phone"].toString()+"\n"+land["user"]["email"]),
                    ),
                  ),
                  ListTile(
                    title: Text('Country'),
                    subtitle: Text(land['landcountry']),
                  ),
                  ListTile(
                    title: Text('State'),
                    subtitle: Text(land['landstate']),
                  ),
                  ListTile(
                    title: Text('District'),
                    subtitle: Text(land['landdistrict']),
                  ),
                  ListTile(
                    title: Text('City'),
                    subtitle: Text(land['landcity']),
                  ),
                  ListTile(
                    title: Text('Landmark'),
                    subtitle: Text(land['landlandmark']),
                  ),
                  ListTile(
                    title: Text('Pincode'),
                    subtitle: Text(land['landpincode'].toString()),
                  ),
                  ListTile(
                    title: Text('Square Feet'),
                    subtitle: Text(land['squarefeet'].toString()),
                  ),
                  ListTile(
                    title: Text('Soil Type'),
                    subtitle: Text(land['soiltype']),
                  ),
                  ListTile(
                    title: Text('Water Availability'),
                    subtitle: Text(land['water']),
                  ),

                  // Container(
                  //   padding: EdgeInsets.all(30),
                  //   child: ElevatedButton(
                  //     child: Text("Connect",style: TextStyle(fontSize: 20),),
                  //     onPressed: (){
                  //       connectWithLandOwner();
                  //     },
                  //   ),
                  // )
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
