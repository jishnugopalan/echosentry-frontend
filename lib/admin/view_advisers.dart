import 'package:dio/dio.dart';
import 'package:echosentry/admin/admin_menu.dart';
import 'package:echosentry/customer/customermenu.dart';
import 'package:echosentry/customer/view_adviser.dart';
import 'package:echosentry/services/admin_service.dart';
import 'package:flutter/material.dart';

class ViewAdviserAdmin extends StatefulWidget {
  const ViewAdviserAdmin({Key? key}) : super(key: key);

  @override
  State<ViewAdviserAdmin> createState() => _ViewAdviserAdminState();
}

class _ViewAdviserAdminState extends State<ViewAdviserAdmin> {
  AdminService service=AdminService();
  List<dynamic> data = [];
  getAllAdvisers() async {
    try{
      final Response? response = await service.viewAllAdvisers();

      final jsonData = response!.data as List<dynamic>;
      print(jsonData);
      setState(() {
        data = jsonData;
      });

    }on DioError catch(e){
      showError("Error in fetching details", "Oops!");
    }
  }
  gotoAdviser(adviser){
    print(adviser);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ViewAdviser(adviserid: adviser),
      ),
    );
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllAdvisers();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Advisers"),
      ),
      drawer: AdminMenu(),
      body: ListView.builder(
        itemCount: data.length,
        padding: EdgeInsets.all(10),

        itemBuilder: (BuildContext context, int index) {

          return ListTile(


              title: Text(data[index]["name"] ?? "ggg",style: TextStyle(fontWeight: FontWeight.w600,fontSize:20,),),
              leading: Icon(Icons.account_circle,size: 50,color: Colors.blueAccent,),
              subtitle: Text(data[index]["phone"].toString()+"\n"+data[index]["email"],style: TextStyle(fontSize: 16),),


              tileColor: data[index]['order_status']=="Payment Completed"?Colors.greenAccent[100]:Colors.grey[100]
          );
        },
      ),

    );
  }
}
