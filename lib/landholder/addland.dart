import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:echosentry/landholder/landmenu.dart';
import 'package:echosentry/services/land_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
class AddLand extends StatefulWidget {
  @override
  _AddLandState createState() => _AddLandState();
}

class _AddLandState extends State<AddLand> {
  final _formKey = GlobalKey<FormState>();
  LandService service=LandService();
  XFile? _imageFile;
  String? _landCountry="India";
  String? _landState;
  String? _landDistrict="Alappuzha";
  String? _landCity;
  String? _landLandmark;
  String? _landPincode;
  String? _squareFeet;
  String? _soilType;
  String? _water;
  final storage = const FlutterSecureStorage();
  final List<String> items = [
    'Alappuzha',
    'Ernakulam',
    'Idukki',
    'Kannur',
    'Kasaragod',
    'Kollam',
    'Kottayam',
    'Kozhikode',
    'Malappuram',
    'Palakkad',
    'Pathanamthitta',
    'Thiruvananthapuram',
    'Thrissur',
    'Wayanad'
  ];
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
  submitLand() async {
    Map<String, String> allValues = await storage.readAll();
    String? userid=allValues["userid"];
    List<String>? s=_imageFile?.path.toString().split("/");
    final bytes=await File(_imageFile!.path).readAsBytes();
    final base64=base64Encode(bytes);
    var pic="data:image/"+s![s.length-1].split(".")[1]+";base64,"+base64;
    var landdetails=jsonEncode({
      "user":userid,
      "landcountry":_landCountry,
      "landstate":_landState,
      "landdistrict":_landDistrict,
      "landcity":_landCity,
      "landlandmark":_landLandmark,
      "landpincode":_landPincode,
      "landphoto":pic,
      "squarefeet":_squareFeet,
      "soiltype":_soilType,
      "water":_water
    });
    try{
      final Response res=await service.addLand(landdetails);
      print(res);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Land Added"),
              content: Text("Land added successfully"),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Land"),

      ),
      drawer: LandMenu(),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
        Form(
          
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  Text("Select land image"),
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
            TextFormField(
              decoration: InputDecoration(labelText: 'Land Country'),

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter land country';
                }
                return null;
              },
              readOnly: true,
              onSaved: (value) {
                _landCountry = value;
              },
              initialValue: "India",

            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Land State'),

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter land state';
                }
                return null;
              },
              readOnly: true,
              onSaved: (value) {
                _landState = value;
              },
              initialValue: "Kerala",

            ),
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                hint: Row(
                  children: const [
                    Icon(
                      Icons.list,
                      size: 16,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Text(
                        'Select District',
                        style: TextStyle(
                          //fontSize: 14,
                          // fontWeight: FontWeight.bold,
                          //color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                items: items
                    .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,

                    overflow: TextOverflow.ellipsis,
                  ),
                ))
                    .toList(),
                value: _landDistrict,
                onChanged: (value) {
                  //print(value);
                  setState(() {
                    _landDistrict = value as String;
                  });

                },


                icon: const Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
                iconSize: 14,
                //iconEnabledColor: Colors.black,
                iconDisabledColor: Colors.grey,
                buttonHeight: 50,
                buttonWidth: 160,

                buttonElevation: 2,
                itemHeight: 40,
                itemPadding: const EdgeInsets.only(left: 14, right: 14),
                dropdownMaxHeight: 200,
                dropdownWidth: 200,
                dropdownPadding: null,
                // dropdownDecoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(14),
                //   color: Colors.redAccent,
                // ),

                scrollbarAlwaysShow: true,
                offset: const Offset(-10, 0),
              ),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Land City'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter land city';
                }
                return null;
              },
              onSaved: (value) {
                _landCity = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Land Landmark'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter land landmark';
                }
                return null;
              },
              onSaved: (value) {
                _landLandmark = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Land Pincode'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter land pincode';
                }
                return null;
              },
              onSaved: (value) {
                _landPincode = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Square Feet'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter square feet';
                }
                return null;
              },
              onSaved: (value) {
                _squareFeet = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Soil Type'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter soil type';
                }
                return null;
              },
              onSaved: (value) {
                _soilType = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Water Availability'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter water availability';
                }
                return null;
              },
              onSaved: (value) {
                _water = value;
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  submitLand();
                  // Do something with the form data
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      )
        ],
      ),
    );
  }
}
