import 'dart:ffi';
import 'dart:io';

import 'package:echosentry/shop/shopmenu.dart';
import 'package:flutter/material.dart';
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
  List<String> category = <String>['Seeds', 'Pots', 'Tools/Machineries', 'Fertilizers'];
  List<String> subcategory = <String>['Vegetable Seeds', 'Metal Planters', 'Sickle', 'Nitrogen Fertilizer'];
  XFile? _imageFile;
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
                              print("vaidation passeds");
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
