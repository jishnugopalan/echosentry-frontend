import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:echosentry/services/registration_services.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:image_picker/image_picker.dart';
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String name="",email="",phone="",usertype="customer",password="",confirm_passord="";
  String place="",house="",pincode="";
  String? district="Alappuzha";
  String shopname="",shopemail="",shopphone="",shopplace="",shopdistrict="Alappuzha";
  String shoppincode="",shoppic="",shoplicenseno="";
  XFile? _imageFile;
  RegistrationService service=RegistrationService();
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
  Future<void> signUp() async {
    if(_formkey.currentState!.validate()){
      if(usertype=="customer" || usertype=="landowner"){
        var user=jsonEncode({
          "name":name,
          "email":email,
          "phone":phone,
          "usertype":usertype,
          "password":password,
          "housename":house,
          "place":place,
          "district":district,
          "pincode":pincode
        });
        print(user);
        try{
          final response=await service.registerUser(user);
          showError("Registration process completed", "Registration Successful");
        }on DioError catch(e){
          if (e.response != null) {
            print(e.response!.data);

            showError(e.response!.data["error"], "Registration Failed");


          } else {
            // Something happened in setting up or sending the request that triggered an Error
           showError("Error occured,please try againlater","Oops");
          }

        }





      }
      else{
        List<String>? s=_imageFile?.path.toString().split("/");
        final bytes=await File(_imageFile!.path).readAsBytes();
        final base64=base64Encode(bytes);
        var pic="data:image/"+s![s.length-1].split(".")[1]+";base64,"+base64;
        print(pic);
        var user=jsonEncode({
          "name":name,
          "email":email,
          "phone":phone,
          "usertype":usertype,
          "password":password,
          "shopname":shopname,
          "shopphone":shopphone,
          "shopemail":shopemail,
          "shopplace":shopplace,
          "shopdistrict":shopdistrict,
          "shoppincode":shoppincode,
          "shoplicenseno":shoplicenseno,
          "shoppic":pic

        });
        print(user);
        try{
          final response=await service.registerUser(user);
          showError("Registration process completed", "Registration Successful");
        }on DioError catch(e){
          if (e.response != null) {
            print(e.response!.data);

            showError(e.response!.data["error"], "Registration Failed");


          } else {
            // Something happened in setting up or sending the request that triggered an Error
            showError("Error occured,please try againlater","Oops");
          }

        }
      }
      // print(user);
      // Users user=new Users(name, email, phone, password, usertype);
      // String userdata=jsonEncode(user);
      // print(userdata);
      // var client = http.Client();
      // try{
      //   var response = await client.post(
      //       Uri.parse("http://10.0.2.2:3000/api/register"),
      //       headers:{"Content-Type":"application/Json"},
      //       body: jsonEncode(user));
      //   print(response.body);
        // String res=jsonDecode(response.body);


    //     if(response.statusCode==404){
    //       showDialog(context: context, builder: (BuildContext context ){
    //         return AlertDialog(
    //           title: Text("Error"),
    //           content: Text('error'),
    //           actions: [
    //             TextButton(
    //               child: Text("Ok"),
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //             )
    //           ],
    //         );
    //       });
    //     }
    //     else{
    //
    //     }
    //
    //   }
    //   catch(e){
    //     print(e);
    //     showDialog(context: context, builder: (BuildContext context ){
    //       return AlertDialog(
    //         title: Text("Error"),
    //         content: Text("Error in signup"),
    //         actions: [
    //           TextButton(
    //             child: Text("Ok"),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //           )
    //         ],
    //       );
    //     });
    //
    //   }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
              children: [
                Form(
                  key: _formkey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/signup.png',height: 300,),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),

                        Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              // ignore: prefer_const_constructors

                              TextFormField(
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                   labelText: 'Full Name',
                                  // labelStyle: TextStyle(color: Color.fromARGB(255, 53, 87, 33)),
                                  //hintText: "First Name",
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(255, 53, 87, 33),
                                        )
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(255, 53, 87, 33),
                                        ))),
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if(value!.isEmpty){
                                    return "Name is required";
                                  }
                                  setState(() {
                                    name=value;
                                  });
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              TextFormField(
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    labelText: 'Email',
                                    // labelStyle: TextStyle(color: Color.fromARGB(255, 53, 87, 33)),
                                    //hintText: "First Name",
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(255, 53, 87, 33),
                                        )),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(255, 53, 87, 33),
                                        ))),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if(value!.isEmpty){
                                    return "Email is required";
                                  }
                                  setState(() {
                                    email=value;
                                  });
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),


                              TextFormField(
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    labelText: 'Phone',
                                    // labelStyle: TextStyle(color: Color.fromARGB(255, 53, 87, 33)),
                                    //hintText: "First Name",
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(255, 53, 87, 33),
                                        )),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(255, 53, 87, 33),
                                        ))),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if(value!.isEmpty){
                                    return "Phone is required";
                                  }
                                  else if(value.length<10 || value.length>10){
                                    return "Phone number should have 10 numbers";
                                  }
                                  setState(() {
                                    phone=value;
                                  });
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Sign up as",
                                  style: TextStyle(
                                      fontSize: 16, color: Color.fromARGB(255, 53, 87, 33)),
                                ),
                              ),


                              RadioListTile(
                                title: Text("Customer"),
                                value: "customer",

                                groupValue: usertype,

                                onChanged: (value){
                                  setState(() {
                                    usertype = value.toString();
                                  });
                                },

                              ),

                              RadioListTile(
                                title: Text("Shop"),
                                value: "shop",
                                groupValue: usertype,
                                onChanged: (value){
                                  setState(() {
                                    usertype = value.toString();
                                  });
                                },
                              ),

                              RadioListTile(
                                title: Text("Land Owner"),
                                value: "landowner",
                                groupValue: usertype,
                                onChanged: (value){
                                  setState(() {
                                    usertype = value.toString();
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              //customer info
                              if(usertype=="customer" || usertype=="landowner")...[

                                const SizedBox(
                                  height: 20,
                                ),

                                TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      labelText: 'House name',
                                      // labelStyle: TextStyle(color: Color.fromARGB(255, 53, 87, 33)),
                                      //hintText: "First Name",
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 53, 87, 33),
                                          )),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 53, 87, 33),
                                          ))),
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if(value!.isEmpty){
                                      return "House name is required";
                                    }
                                    setState(() {
                                      house=value;
                                    });
                                    return null;
                                  },
                                ),

                                const SizedBox(
                                  height: 20,
                                ),



                                TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      labelText: 'Place',
                                      // labelStyle: TextStyle(color: Color.fromARGB(255, 53, 87, 33)),
                                      //hintText: "First Name",
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 53, 87, 33),
                                          )),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 53, 87, 33),
                                          ))),
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if(value!.isEmpty){
                                      return "Place is required";
                                    }
                                    setState(() {
                                      place=value;
                                    });
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),

                                Container(
                                    //padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*.02,right:MediaQuery.of(context).size.width*.02,top: MediaQuery.of(context).size.height*.02),
                                    child: InputDecorator(
                                      decoration: InputDecoration(

                                        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),


                                      ),
                                      child: DropdownButtonHideUnderline(
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
                                          value: district,
                                          onChanged: (value) {
                                            //print(value);
                                            setState(() {
                                              district = value as String;
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
                                    )),
                                const SizedBox(
                                  height: 20,
                                ),


                                TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      labelText: 'Pin code',
                                      // labelStyle: TextStyle(color: Color.fromARGB(255, 53, 87, 33)),
                                      //hintText: "First Name",
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 53, 87, 33),
                                          )),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 53, 87, 33),
                                          ))),
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if(value!.isEmpty){
                                      return "Pin code is required";
                                    }
                                    else if(value.length<6 || value.length>6){
                                      return "Pin code should have 6 numbers";
                                    }
                                    setState(() {
                                      pincode=value;
                                    });
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),

                              ]
                                //shop
                              else if(usertype=="shop")...[

                                const SizedBox(
                                  height: 20,
                                ),

                                TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      labelText: 'Shop name',
                                      // labelStyle: TextStyle(color: Color.fromARGB(255, 53, 87, 33)),
                                      //hintText: "First Name",
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 53, 87, 33),
                                          )),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 53, 87, 33),
                                          ))),
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if(value!.isEmpty){
                                      return "Shop name is required";
                                    }
                                    setState(() {
                                      shopname=value;
                                    });
                                    return null;
                                  },
                                ),

                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      labelText: 'Shop Email',
                                      // labelStyle: TextStyle(color: Color.fromARGB(255, 53, 87, 33)),
                                      //hintText: "First Name",
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 53, 87, 33),
                                          )),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 53, 87, 33),
                                          ))),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if(value!.isEmpty){
                                      return "Shop email is required";
                                    }
                                    setState(() {
                                      shopemail=value;
                                    });
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      labelText: 'Shop Phone',
                                      // labelStyle: TextStyle(color: Color.fromARGB(255, 53, 87, 33)),
                                      //hintText: "First Name",
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 53, 87, 33),
                                          )),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 53, 87, 33),
                                          ))),
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if(value!.isEmpty){
                                      return "Shop phone number is required";
                                    }
                                    else if(value.length>10 || value.length<10){
                                      return "Shop phone number is required";
                                    }
                                    setState(() {
                                      shopphone=value;
                                    });
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),



                                TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      labelText: 'Shop Place',
                                      // labelStyle: TextStyle(color: Color.fromARGB(255, 53, 87, 33)),
                                      //hintText: "First Name",
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 53, 87, 33),
                                          )),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 53, 87, 33),
                                          ))),
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if(value!.isEmpty){
                                      return "Shop place is required";
                                    }
                                    setState(() {
                                      shopplace=value;
                                    });
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),

                                Container(
                                  //padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*.02,right:MediaQuery.of(context).size.width*.02,top: MediaQuery.of(context).size.height*.02),
                                    child: InputDecorator(
                                      decoration: InputDecoration(

                                        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),


                                      ),
                                      child: DropdownButtonHideUnderline(
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
                                          value: shopdistrict,
                                          onChanged: (value) {
                                            // print(value);
                                            setState(() {
                                              shopdistrict = value as String;
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
                                    )),
                                const SizedBox(
                                  height: 20,
                                ),


                                TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      labelText: 'Shop Pin code',
                                      // labelStyle: TextStyle(color: Color.fromARGB(255, 53, 87, 33)),
                                      //hintText: "First Name",
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 53, 87, 33),
                                          )),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 53, 87, 33),
                                          ))),
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if(value!.isEmpty){
                                      return "Pin code is required";
                                    }
                                    else if(value.length<6 || value.length>6){
                                      return "Pin code should have 6 numbers";
                                    }
                                    setState(() {
                                      shoppincode=value;
                                    });
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      labelText: 'Shop License Number',
                                      // labelStyle: TextStyle(color: Color.fromARGB(255, 53, 87, 33)),
                                      //hintText: "First Name",
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 53, 87, 33),
                                          )),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 53, 87, 33),
                                          ))),
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if(value!.isEmpty){
                                      return "Shop license number is required";
                                    }

                                    setState(() {
                                      shoplicenseno=value;
                                    });
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  child: Column(
                                   children: [
                                     Align(
                                       alignment: Alignment.center,
                                       child: Text(
                                         "Select Shop Image/Shop Logo",
                                         style: TextStyle(
                                             fontSize: 16),
                                       ),
                                     ),
                                     Center(
                                       child: _imageFile == null
                                           ? Text('No image selected ')
                                           : Image.file(File(_imageFile!.path),width: 360,height:240 ,),
                                     ),
                                     SizedBox(
                                       height: 20,
                                     ),
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [

                                         GestureDetector(

                                           child: Container(
                                             alignment: Alignment.center,
                                             child: Icon(Icons.photo_camera_rounded,size: 35,),
                                           ),
                                           onTap: getImageFromCamera,
                                         ),
                                         SizedBox(
                                           width: 20,
                                         ),
                                         GestureDetector(

                                           child: Container(
                                             alignment: Alignment.center,
                                             child: Icon(Icons.image_outlined,size: 35,),
                                           ),
                                           onTap: getImageFromGallery,
                                         ),

                                       ],
                                     )
                                   ],
                                  ),
                                ),


                              ],
                              const SizedBox(
                                height: 20,
                              ),

                              TextFormField(
                                obscureText: true,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                   labelText: 'Password',

                                  // labelStyle: TextStyle(color: Color.fromARGB(255, 53, 87, 33)),
                                  //hintText: "First Name",

                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(255, 53, 87, 33),
                                        )),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(255, 53, 87, 33),
                                        ))),
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if(value!.isEmpty){
                                    return "Password is required";
                                  }
                                  setState(() {
                                    password=value;
                                  });
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                obscureText: true,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    labelText: 'Confirm Password',

                                    // labelStyle: TextStyle(color: Color.fromARGB(255, 53, 87, 33)),
                                    //hintText: "First Name",

                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(255, 53, 87, 33),
                                        )),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(255, 53, 87, 33),
                                        ))),
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  if(value!.isEmpty){
                                    return "Password is required";
                                  }
                                  if(value!=password){
                                    return "Write the same password as above";
                                  }

                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: MaterialButton(
                              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10.0) ),
                              color: Colors.green,

                              onPressed:signUp,
                            child: Text(
                              'Register',
                              style: TextStyle(color: Colors.white,fontSize: 18),
                            ),
                            //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserSignUp2()));


                          ),
                        ),
                      ]),
                ),
              ]
          ),
        )
    );
  }
}
