import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:echosentry/landholder/landmenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../services/land_service.dart';


class LandViewPage extends StatefulWidget {
  const LandViewPage({Key? key, required this.landId}) : super(key: key);
  final String landId;

  @override
  State<LandViewPage> createState() => _LandViewPageState();
}

class _LandViewPageState extends State<LandViewPage> {
  LandService service=LandService();
  late final Response res;
  late final Response response;
  final storage = const FlutterSecureStorage();
  List<dynamic> data = [];
  String landcity="",squarefeet="",water="",pincode="",district="";
  String landpic="data:image/png;base64,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RERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERENHP/P6Y3+m8Ohq3KAAAAAElFTkSuQmCC";

   _fetchLandDetails() async {
    res = await service.viewLand(widget.landId);
    print(res.data["user"]["name"]);
    setState(() {
      landpic=res.data["landphoto"];
      landcity=res.data["landcity"];
      squarefeet=res.data["squarefeet"].toString();
      water=res.data["water"];
      pincode=res.data["landpincode"].toString();
      district=res.data["landdistrict"];
    });

   }
  getConnectedPeople() async {
    try{
      response=await service.viewConnectionByLandOwner(widget.landId);
      print(response);
      final jsonData = response.data as List<dynamic>;
      print(jsonData);
      setState(() {
        data = jsonData;
      });

    }on DioError catch(e){

      print(e.response!.data);
    }
  }
  acceptConnection(index) async {
     String connectionid=data[index]["_id"];
     print(connectionid);
     try{
       final Response r=await service.updateLandConnection(connectionid, "accepted");
       print(r);
       // initState();
       setState(() {
         data[index]["status"]="accepted";
       });
       //showError("Connection accepted", "Accepted");

     }on DioError catch(e){
       showError("Error in updation", "Error");
     }


  }
  rejectConnection(index) async {
    String connectionid=data[index]["_id"];
    print(connectionid);
    try{
      final Response r=await service.updateLandConnection(connectionid, "rejected");
      print(r);
      setState(() {
        data[index]["status"]="rejected";
      });
    //  showError("Connection rejected", "Rejected");

    }on DioError catch(e){

      showError("Error in updation", "Error");
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
                  if(title=="Registration Successful"){
                    Navigator.pushNamed(context, '/login');
                  }
                  else
                    Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchLandDetails();
    getConnectedPeople();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Land"),
      ),
      drawer: LandMenu(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Image.memory(
                  base64Decode(landpic.split(',')[1]),
                  fit: BoxFit.cover,
                  //errorBuilder:  (context, base64, error) => new Icon(Icons.error),
                ),
                ListTile(
                  title: Text('District'),
                  subtitle: Text(district!),
                ),
                ListTile(
                  title: Text('City'),
                  subtitle: Text(landcity),
                ),
                ListTile(
                  title: Text('Square Feet'),
                  subtitle: Text(squarefeet),
                ),
                Container(
                  child: Text("Connections",style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                )
              ],
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Container(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  padding: EdgeInsets.all(10),
                 child: Card(
                   color: Colors.grey[200],
                   child: Column(
                     children: [
                       Container(
                         child:  Text(data[index]["user"]["name"],style: TextStyle(fontSize: 16),),
                         alignment: Alignment.topLeft,
                         padding: EdgeInsets.all(10),
                       ),
                       Container(
                         child:  Text(data[index]["user"]["phone"].toString(),style: TextStyle(fontSize: 16),),
                         alignment: Alignment.topLeft,
                         padding: EdgeInsets.all(10),
                       ),
                       if(data[index]["status"]=="request sent")...[
                         Container(
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.end,
                             children: [
                               ElevatedButton(onPressed: (){
                                 acceptConnection(index);
                               }, child: Text("Accept")),
                               SizedBox(
                                 width: 10,
                               ),
                               ElevatedButton(onPressed: (){
                                 rejectConnection(index);
                               }, child: Text("Reject"))

                             ],
                           ),
                         )
                       ]else if(data[index]["status"]=="accepted")...[
                         Container(

                           child: Text("Accepted",style: TextStyle(color: Colors.green)),
                           alignment: Alignment.bottomRight,
                         )
                       ]else if(data[index]["status"]=="rejected")...[
                         Container(

                           child: Text("Rejected",style: TextStyle(color: Colors.red)),
                           alignment: Alignment.bottomRight,
                         )
                       ]

                     ],
                   ),
                 ),
                );
              },
              childCount: data.length,
            ),
          ),

        ],
      ),

    );
  }
}
