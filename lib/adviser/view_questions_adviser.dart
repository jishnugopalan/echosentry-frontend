import 'package:dio/dio.dart';
import 'package:echosentry/adviser/addanswer.dart';
import 'package:echosentry/adviser/adviser_menu.dart';
import 'package:echosentry/services/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class ViewQuestionsAdviser extends StatefulWidget {
  const ViewQuestionsAdviser({Key? key}) : super(key: key);

  @override
  State<ViewQuestionsAdviser> createState() => _ViewQuestionsAdviserState();
}

class _ViewQuestionsAdviserState extends State<ViewQuestionsAdviser> {
  AdminService service=AdminService();
  List<dynamic> data = [];
  late final Response response;
  final storage = const FlutterSecureStorage();
  getQuestions() async {

    Map<String, String> allValues = await storage.readAll();
    String? userid=allValues["userid"];
    try{
      response = await service.viewQuestionsByAdviser(userid!);

      final jsonData = response.data as List<dynamic>;
      print(jsonData);
      setState(() {
        data = jsonData;
      });
    }on DioError catch(e){


      showError("Error in fetching questions", "Oops!");
    }

  }
  getQuestionDetails(index){
    final jsonData = response.data as List<dynamic>;
    print(jsonData[index]);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>AddAnswer(questionid: jsonData[index]["_id"] ,),
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
    getQuestions();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Questions"),
      ),
      drawer: AdviserMenu(),
      body: ListView.builder(
        itemCount: data.length,
        padding: EdgeInsets.all(10),

        itemBuilder: (BuildContext context, int index) {
          // String productname="";
          // productname=data[index]['productname'];
          DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(int.parse(data[index]['timestamp']) * 1000);
          String formattedDate = DateFormat.yMd().add_Hms().add_jm().format(dateTime);
          print(formattedDate);


          return Column(
            children: [
              Card(
                child: ListTile(


                title: Text("Question :"+data[index]["question"] ?? "ggg",style: TextStyle(fontWeight: FontWeight.w500,fontSize:20),),
                // subtitle: Text("₹"+data[index]['total_price'].toString()+"\n"+data[index]['order_status']+"\n"+formattedDate,style: TextStyle(fontSize: 16),),
                // trailing: Icon(Icons.shopping_bag,color: Colors.blue,),
                // onTap: (){
                //   gotoPaymentPage(data[index]["_id"]);
                // },
                    subtitle: data[index]['answer']==null?Text("Not Answered",style: TextStyle(color: Colors.red),):Text(""),
                //tileColor: data[index]['answer']==null?Colors.greenAccent[100]:Colors.redAccent[100]
                  onTap: (){

                  getQuestionDetails(index);
                  },

                ),
              )
            ],
          );
        },
      ),
    );
  }
}
