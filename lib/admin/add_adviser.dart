import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:echosentry/services/admin_service.dart';
import 'package:flutter/material.dart';


class AddAdviser extends StatefulWidget {
  const AddAdviser({Key? key}) : super(key: key);

  @override
  State<AddAdviser> createState() => _AddAdviserState();
}

class _AddAdviserState extends State<AddAdviser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _phone = '';
  AdminService service=AdminService();

  addAdviser() async {
    String password="";
    for(int i=0;i<_name.length;i++){
      if(i<3){
        password=password+_name[i];
      }
    }
    for(int i=0;i<_phone.length;i++){
      if(i>6){
        password=password+_phone[i].toString();

      }
    }
    print(password);
    var adviser=jsonEncode({
      "name":_name,
      "email":_email,
      "phone":_phone,
      "password":password,
      "usertype":"adviser"
    });
    try{
      final Response res=await service.addAdviser(adviser);
      print(res);
      showError("Adviser registration successful", "Registration Successful");


    }on DioError catch(e){
      showError("Adviser registration failed", "Failed");
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Adviser'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (value) => _name = value!,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value!,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                  onSaved: (value) => _phone = value!,
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      addAdviser();
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
