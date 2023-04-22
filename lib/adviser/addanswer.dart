

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:echosentry/adviser/adviser_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

import '../services/admin_service.dart';

class AddAnswer extends StatefulWidget {
  const AddAnswer({Key? key, required this.questionid}) : super(key: key);
  final String questionid;

  @override
  State<AddAnswer> createState() => _AddAnswerState();
}

class _AddAnswerState extends State<AddAnswer> {
  AdminService service=AdminService();
  List<dynamic> data = [];
  final storage = const FlutterSecureStorage();
  String name="",email="",phone="";
  String quesion="",answer="",timestamp="";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  getQuestion() async {
    try {
      final Response? response = await service.getQuestionById(widget.questionid);

      print(response);
      setState(() {
        name=response!.data["user"]["name"];
        email=response.data["user"]["email"];
        phone=response.data["user"]["phone"].toString();
        quesion=response.data["question"];
        if(response.data["answer"]!=null){
          answer=response.data["answer"];
        }
        timestamp=response.data["timestamp"];

      });
      DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(int.parse(timestamp) * 1000);
      String formattedDate = DateFormat.yMd().add_Hms().add_jm().format(dateTime);
      setState(() {
        timestamp=formattedDate;
      });

    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response!.data);

        showError(e.response!.data["error"], "Failed");
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        showError("Error occured,please try again later", "Oops");
      }
    }

  }
  addAnswer() async {
    Map<String, String> allValues = await storage.readAll();
    String? userid=allValues["userid"];
    var ques=jsonEncode({
      "questionid":widget.questionid,
      "answer":_nameController.text
    });
    try{
      final Response res=await service.addAnswer(ques);
      print(res);
      showError("Answer added successfully", "Answer Added");
    }on DioError catch(e){
      showError(e.response!.data["msg"], "Oops!");
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
    getQuestion();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Answer"),
      ),
      drawer: AdviserMenu(),
      body: ListView(
        children: [
          ListTile(
            title: Text("Customer Name: "+name),
            subtitle: Text("Email: "+email+"\n"+"Phone: "+phone),
          ),
          ListTile(
            title: Text("Question: "+quesion,),
            subtitle: Text("Posted on: "+timestamp,),
          ),
          Form(
            key: _formKey,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                hintText: 'Enter your answe',
                ),
                validator: (value) {
                if (value!.isEmpty) {
                 return 'Please enter your answer';
                }


                return null;
                },
                ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
              onPressed: () {
              if (_formKey.currentState!.validate()) {
                 print(_nameController.text);
                 addAnswer();
                }
              },
              child: Text('Submit'),
              ),
            ),

            ],
            ),
          ),


        ],
      ),
    );
  }
}
