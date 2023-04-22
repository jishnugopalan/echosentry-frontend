import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:echosentry/customer/customermenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../services/admin_service.dart';


class ViewAdviser extends StatefulWidget {
  const ViewAdviser({Key? key, required this.adviserid}) : super(key: key);
  final String adviserid;

  @override
  State<ViewAdviser> createState() => _ViewAdviserState();
}

class _ViewAdviserState extends State<ViewAdviser> {
  AdminService service=AdminService();
  String name="",email="",phone="";
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  String _questionText = '';
  String _answerText = '';
  getAdviserDetails() async {
    try{
      final Response response = await service.viewAdviserById(widget.adviserid);
      print(response);
      setState(() {
        name=response.data["name"].toString();
        email=response.data["email"].toString();
        phone=response.data["phone"].toString();


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
  addQuestion() async {

    Map<String, String> allValues = await storage.readAll();
    String? userid=allValues["userid"];
    var ques=jsonEncode({
      "user":userid,
      "adviser":widget.adviserid,
      "question":_questionText
    });
    print(ques);
    try{
      final Response res=await service.addQuestion(ques);
      print(res);
      showError("Question added successfully", "Questions Added");

    }on DioError catch(e){
      showError("Error in getting details", "Error");
    }

  }
  viewQuestionAndAnswers(){

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.adviserid);
    getAdviserDetails();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adviser"),
      ),
      drawer: CustomerMenu(),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          ListTile(
            title: Text(name),
            subtitle: Text(phone+"\n"+email),
            leading: Icon(Icons.account_circle,size: 50,color: Colors.blueAccent,),
          ),
        SizedBox(
          height: 20,
        ),
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Add Question',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a question';
                  }
                  setState(() {
                    _questionText = value!;
                  });
                  return null;
                },

              ),
    
              SizedBox(height: 16),
              ElevatedButton(onPressed: (){
                    if (_formKey.currentState!.validate()) {

                      addQuestion();
                    }
                  },
                  child: Text("Submit"))

            ],
          ),
         )
        ],
      ),
    );
  }
}
