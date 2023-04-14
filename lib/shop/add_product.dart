import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:echosentry/services/addproduct_service.dart';
import 'package:echosentry/shop/shopmenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';


class AddProducts extends StatefulWidget {
  const AddProducts({Key? key}) : super(key: key);

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  final _formKey=GlobalKey<FormState>();
  String? dropdownValue=null;
  String? dropdownValue2=null;
  String? product_name,product_description,product_price,product_quantity,product_stock;
  String? categoryid,subcategoryid;
  List<String> category = <String>[];
  List<String> subcategory = <String>[];
  XFile? _imageFile;
  late final Response? response;
  late final Response? response2;
  AddProductService service=AddProductService();
  final storage = const FlutterSecureStorage();
  Future<void> getImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = image;
    });
  }
  Future<void> getImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = image;
    });
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
  Future<void>getCategory()async{
    try{
      response=await service.getAllCategory();
      print(response!.data);
      final jsonData = response!.data;

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
  Future<void>getSubcategory()async{
    final jsonData = response!.data;
    String c="";

    for(int i=0;i<jsonData.length;i++){
      if(jsonData[i]["category"]==dropdownValue){
        c=jsonData[i]["_id"];
        setState(() {
          categoryid=jsonData[i]["_id"];
        });
        break;
      }
    }



    try{
      response2=await service.getSubCategory(c);
      print(response2!.data);
      final jsonData2 = response2!.data;
      subcategory.clear();
      for(int i=0;i<jsonData2.length;i++){

        setState(() {
          subcategory.add(jsonData2[i]["subcategory"]);
        });
      }
    }on DioError catch(e){
      if (e.response != null) {
        print(e.response!.data);
        showError("Failed", "Error in getting categories");
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        showError("Error occured,please try againlater","Oops");
      }
    }
  }
  getSubcategoryId(){
    final jsonData = response2!.data;
    String c="";

    print(jsonData);
    for(int i=0;i<jsonData.length;i++){
      if(jsonData[i]["subcategory"]==dropdownValue2){
        c=jsonData[i]["_id"];
        //print(c);
        setState(() {
          subcategoryid=jsonData[i]["_id"];
        });
        break;
      }
    }

  }
  addProduct() async {
    Map<String, String> allValues = await storage.readAll();
    String? userid=allValues["userid"];
    //print(allValues["userid"]);
    String shopid="";
    try{
      final Response? response3=await service.getShopId(userid!);
      shopid=response3!.data["_id"];
    }on DioError catch(e){
      if (e.response != null) {
        print(e.response!.data);
        showError("Failed", "Failed");
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        showError("Error occured,please try againlater","Oops");
      }
    }
    print(shopid);
    List<String>? s=_imageFile?.path.toString().split("/");
    final bytes=await File(_imageFile!.path).readAsBytes();
    final base64=base64Encode(bytes);
    var pic="data:image/"+s![s.length-1].split(".")[1]+";base64,"+base64;
    var product=jsonEncode({
      "shopid": shopid,
      "productname": product_name,
      "category": categoryid,
      "subcategory": subcategoryid,
      "price": product_price,
      "stock": product_stock,
      "image":pic,
      "description":product_description

    });
    print(product);
    try{
      final Response? response4=await service.addProduct(product);
      print(response4);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Product Added"),
              content: Text("$product_name added successfully"),
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

    }on DioError catch(e){
      if (e.response != null) {
        print(e.response!.data);
        showError("Failed", "Failed");
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        showError("Error occured,please try againlater","Oops");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCategory();
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Add Products"),

      ),
      drawer: ShopMenu(menuindex: 2,),
      body: Container(
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Text("Add Products",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Text("Select Product image"),
                          IconButton(onPressed: getImageFromCamera, icon: Icon(Icons.camera_alt,color: Colors.blue,)),
                          IconButton(onPressed: getImageFromGallery, icon: Icon(Icons.image,color: Colors.blue,))

                        ],
                      ),
                    ),
                    Container(
                      child: Card(
                        child: _imageFile == null
                            ? Text('No image selected ')
                            : Image.file(File(_imageFile!.path),width: 360,height:240 ,),
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Product Name",
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return "Name is required";
                          }
                          else if(value.length<2){
                            return "Name should contain more than two characters";
                          }
                          setState(() {
                            product_name=value;
                          });
                          return null;
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: DropdownButton(
                        hint: Text("Select Item Category"),
                       value:dropdownValue ,

                        onChanged: (newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                          getSubcategory();
                        },
                        items: category.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),

                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: DropdownButton(
                        hint: Text("Select Sub  Category"),
                        value:dropdownValue2 ,
                        onChanged: (newValue) {
                          setState(() {
                            dropdownValue2 = newValue!;
                          });
                          getSubcategoryId();
                        },
                        items: subcategory.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),

                    ),
                    Container(
                      height: 80,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Product Description",

                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return "Description is required";
                          }
                          else if(value.length<5){
                            return "Description should contain more than five characters";
                          }
                          setState(() {
                            product_description=value;
                          });
                          return null;
                        },

                      ),
                    ),
                    Container(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Price",
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value){
                          if(value!.isEmpty){
                            return "Price is required";
                          }
                          else if(int.parse(value)<=0){
                            return "Please enter a valid price";
                          }
                          setState(() {
                            product_price=value;
                          });
                          return null;
                        },
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Quantity",
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value){
                          if(value!.isEmpty){
                            return "Quantity is required";
                          }
                          else if(int.parse(value)<=0){
                            return "Please enter a valid quantity";
                          }
                          setState(() {
                            product_quantity=value;
                          });
                          return null;
                        },
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Stock",
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value){
                          if(value!.isEmpty){
                            return "Stock is required";
                          }
                          else if(int.parse(value)<=0){
                            return "Please enter a valid stock count";
                          }
                          setState(() {
                            product_stock=value;
                          });
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: SizedBox(
                        width: 400,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,


                          ),

                          child: Text("Add"),
                          onPressed: (){
                            if(_formKey.currentState!.validate()){
                              addProduct();
                            }
                          },
                        ),
                      )
                    )
                  ],
                ),
              ),
            )
            
          ],
          
        ),
      ),
    );
  }
}
