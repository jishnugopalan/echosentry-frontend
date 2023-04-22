import 'package:dio/dio.dart';
import 'package:echosentry/customer/customermenu.dart';
import 'package:echosentry/services/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';


class ViewQuestions extends StatefulWidget {
  const ViewQuestions({Key? key}) : super(key: key);

  @override
  State<ViewQuestions> createState() => _ViewQuestionsState();
}

class _ViewQuestionsState extends State<ViewQuestions> {

  AdminService service=AdminService();
  List<dynamic> data = [];
  List<dynamic> adv=[];
  final storage = const FlutterSecureStorage();
  getQuestions() async {
    Map<String, String> allValues = await storage.readAll();
    String? userid=allValues["userid"];
    try{
      final Response? response = await service.viewQuestionsByCustomer(userid!);

      final jsonData = response!.data as List<dynamic>;
      print(jsonData);
      setState(() {
        data = jsonData;
      });
    }on DioError catch(e){


      showError("Error in fetching questions", "Oops!");
    }

  }
  getAdviserDetails(adviserid) async {
    try{
      final Response response = await service.viewAdviserById(adviserid);
      print(response.data);
      final jsonData = response!.data as List<dynamic>;
      print(jsonData);
      setState(() {
        adv = jsonData;
      });

    }on DioError catch(e){
      showError("Error in fetching detaisl", "Error");
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getQuestions();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Questions"),
      ),
      drawer: CustomerMenu(),
      body: ListView.builder(
        itemCount: data.length,
        padding: EdgeInsets.all(10),

        itemBuilder: (BuildContext context, int index) {
          // String productname="";
          // productname=data[index]['productname'];
          DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(int.parse(data[index]['timestamp']) * 1000);
          String formattedDate = DateFormat.yMd().add_Hms().add_jm().format(dateTime);
          print(formattedDate);

            //
            // final Response response = service.viewAdviserById(data[index]["adviser"]);
            // print(response.data);





          return Column(
            children: [
              Card(
                child: ListTile(


                    title: Text("Question: "+data[index]["question"] ?? "ggg",style: TextStyle(fontWeight: FontWeight.w600,fontSize:20),),
                    subtitle: Text(formattedDate,style: TextStyle(fontSize: 16),),
                    // trailing: Icon(Icons.shopping_bag,color: Colors.blue,),
                    // onTap: (){
                    //   gotoPaymentPage(data[index]["_id"]);
                    // },
                    tileColor: data[index]['answer']==null?Colors.redAccent[100]:Colors.grey[300]
                ),
              ),
              if(data[index]['answer']!=null)...[
                Card(
                  child: ListTile(


                      title: Text("Answer: "+data[index]["answer"] ?? "ggg",style: TextStyle(fontSize:20),),
                     subtitle: Text("Adviser Details"+"\n"+data[index]["adviser"][0]["name"]+"\n"+data[index]["adviser"][0]["phone"].toString(),style: TextStyle(fontSize: 16),),
                      // trailing: Icon(Icons.shopping_bag,color: Colors.blue,),
                      // onTap: (){
                      //   gotoPaymentPage(data[index]["_id"]);
                      // },
                      //tileColor: data[index]['answer']==null?Colors.greenAccent[100]:Colors.grey[100]
                  ),
                ),
              ]else...[
                Card(
                  child: ListTile(


                    title: Text("Not Answered",style: TextStyle(fontSize:18,color: Colors.red),),
                    subtitle: Text("Adviser Details"+"\n"+data[index]["adviser"][0]["name"]+"\n"+data[index]["adviser"][0]["phone"].toString(),style: TextStyle(fontSize: 16),),
                    // trailing: Icon(Icons.shopping_bag,color: Colors.blue,),
                    // onTap: (){
                    //   gotoPaymentPage(data[index]["_id"]);
                    // },
                    //tileColor: data[index]['answer']==null?Colors.greenAccent[100]:Colors.grey[100]
                  ),
                ),
              ]
            ],
          );
        },
      ),
    );
  }
}
