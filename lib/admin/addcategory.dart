import 'package:dio/dio.dart';
import 'package:echosentry/admin/admin_menu.dart';
import 'package:echosentry/services/admin_service.dart';
import 'package:flutter/material.dart';

class AddCategoryForm extends StatefulWidget {
  @override
  _AddCategoryFormState createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<AddCategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final _categoryNameController = TextEditingController();
  AdminService service=AdminService();
  List<dynamic> data = [];

  addCategory() async {
    try{
      final Response res=await service.addCategory(_categoryNameController.text);
      print(res);
      getAllCategory();
      showError("Category added successful", "Category Added");
    }on DioError catch(e){

      showError("Error in adding category", "Oops!");
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
  getAllCategory() async {
    try{
      final Response response=await service.getAllCategory();
      print(response.data);
      final jsonData = response.data as List<dynamic>;
      print(jsonData);
      setState(() {
        data = jsonData;
      });

      // for(int i=0;i<jsonData.length;i++){
      //
      //   setState(() {
      //     category.add(jsonData[i]["category"]);
      //   });
      // }
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
  @override
  void initState() {
    // TODO: implement initState
    getAllCategory();
    super.initState();
  }

  @override
  void dispose() {
    _categoryNameController.dispose();

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Category"),

      ),
      drawer: AdminMenu(),

      body: Form(
        key: _formKey,
        child: ListView(
          
          padding: EdgeInsets.all(20),
          
          children: <Widget>[
            TextFormField(
              controller: _categoryNameController,
              decoration: InputDecoration(
                labelText: 'Category Name',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a category name';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  print(_categoryNameController.text);
                  addCategory();
                }
              },
              child: Text('Add Category'),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text("Categories",textAlign: TextAlign.center,style: TextStyle(fontSize: 20),),
            ),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context,index){
                  return ListTile(


                      title: Text(data[index]["category"] ?? "ggg",style: TextStyle(fontSize:18,color: Colors.green[800]),),

                  );

            })
          ],
        ),
      ),
    );
  }
}
