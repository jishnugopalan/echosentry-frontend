import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:echosentry/services/admin_service.dart';
import 'package:flutter/material.dart';

class AddSubcategoryForm extends StatefulWidget {
  @override
  _AddSubcategoryFormState createState() => _AddSubcategoryFormState();
}

class _AddSubcategoryFormState extends State<AddSubcategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final _subcategoryNameController = TextEditingController();
  String? _selectedCategory;
  List<String> category=[];
  String categoryid="";
  AdminService service=AdminService();
  late final Response response;
  late final Response response2;

  Future<void>getCategory()async{
    try{
      response=await service.getAllCategory();
      print(response.data);
      final jsonData = response.data;

      for(int i=0;i<jsonData.length;i++){

        setState(() {
          category.add(jsonData[i]["category"]);
        });
      }
    }on DioError catch(e){
      if (e.response != null) {
        print(e.response!.data);
        showError(e.response!.data["error"], "Error in getting categories");
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        showError("Error occured,please try againlater","Oops");
      }
    }
  }
  Future<void>getSubcategory()async {

    final jsonData = response!.data;
    String c = "";

    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i]["category"] == _selectedCategory) {
        c = jsonData[i]["_id"];
        setState(() {
          categoryid = jsonData[i]["_id"];
        });
        break;
      }
    }
    print(categoryid);

  }
  addSubcategory() async {
    var subcategory=jsonEncode({
      "categoryid":categoryid,
      "subcategory":_subcategoryNameController.text
    });
    print(subcategory);
    try{
      final Response r=await service.addSubcategory(subcategory);
      print(r.data);

      showError("Subcategory added successful", "Subcategory Added");
    }on DioError catch(e){
      showError("Error in adding subcategory", "Oops!");
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
    getCategory();
    super.initState();
  }
  @override
  void dispose() {
    _subcategoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Subcategory"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DropdownButtonFormField(
              value: _selectedCategory,
              items: category.map<DropdownMenuItem<String>>((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
                getSubcategory();
              },
              decoration: InputDecoration(
                labelText: 'Category',
              ),
              validator: (value) {
                if (value == null) {
                  return 'Please select a category';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _subcategoryNameController,
              decoration: InputDecoration(
                labelText: 'Subcategory Name',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a subcategory name';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                 addSubcategory();
                }
              },
              child: Text('Add Subcategory'),
            ),
          ],
        ),
      ),
    );
  }
}
