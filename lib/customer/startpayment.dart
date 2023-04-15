import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:echosentry/customer/customermenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../services/view_product_service.dart';
import 'package:credit_card_number_validator/credit_card_number_validator.dart';

class StartPaymentPage extends StatefulWidget {
  const StartPaymentPage({Key? key, required this.orderid, required this.productid, required this.vendorid, required this.paymentoption}) : super(key: key);
  final String orderid,productid,vendorid,paymentoption;

  @override
  State<StartPaymentPage> createState() => _StartPaymentPageState();
}

class _StartPaymentPageState extends State<StartPaymentPage> {
  ViewProduct service=ViewProduct();
  String product_name="",category="",subcategory="",description="";
  int price=0,stock=0;
  int _quantity = 1;
  String shopname="",shopphone="",shopdistrict="",shopplac="",shoppincode="";
  String shopid="",order_status="";
  String vendorid="";
  int total_price=0;
  String delevery_option="";
  String payment_option="Online Payment";
  Response? response2;
  final _formKey = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();
  String? _cardNumber;
  String? _expiryDate;
  String? _cvv;
  getOrderDetails() async {
    try{
      response2=await service.viewOrderByOrderid(widget.orderid);
      print(response2!.data);
      setState(() {
        product_name=response2!.data["product"]["productname"];
        // category=response2!.data["product"]["category"]["category"];
        // subcategory=response2!.data["product"]["subcategory"]["subcategory"];
        // image=response2!.data["product"]["image"];
        //description=response2!.data["product"]["description"];
        price=response2!.data["product"]["price"];
       // stock=response2!.data["product"]["stock"];
        shopid=response2!.data["product"]["shopid"];
        total_price=response2!.data["total_price"];
        _quantity=response2!.data["qty"];
        order_status=response2!.data["order_status"];
        delevery_option=response2!.data["delevery_option"];

      });
    }on DioError catch(e){
      if (e.response != null) {
        print(e.response!.data);
        showError("Failed", "Error in getting orders");
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
                  if(title=="Payment Successful"){
                    Navigator.pushReplacementNamed(context, '/order');
                  }
                  else{
                    Navigator.of(context).pop();
                  }


                },
              )
            ],
          );
        });
  }
  startPayment() async {
    Map<String, String> allValues = await storage.readAll();
    String? userid = allValues["userid"];
    var paymentdetails=jsonEncode({
      "order":widget.orderid,
      "product":widget.productid,
      "customerid":userid,
      "user":widget.vendorid,
      "payment_option":widget.paymentoption,
      "payment_status":"Payment Completed",
      "qty":_quantity

    });
    try{
      response2=await service.startPayment(paymentdetails);
      print(response2!.data);
      showError("Payment completed successfully", "Payment Successful");

    }on DioError catch(e){
      if (e.response != null) {
        print(e.response!.data);
        showError("Failed", "Error in getting orders");
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        showError("Error occured,please try againlater","Oops");
      }
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.orderid);
    print(widget.productid);
    print(widget.vendorid);
    print(widget.paymentoption);
    getOrderDetails();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment"),
      ),
      drawer: CustomerMenu(),
      body: ListView(

        children: [
          Card(

            child: Container(
              padding: EdgeInsets.only(left: 5,top: 20,bottom: 20),
              alignment: Alignment.topLeft,

              child: Column(

                children: [
                  ListTile(
                    title: Text(product_name,style: TextStyle(fontSize: 20),),
                    subtitle: Text("₹"+price.toString(),style: TextStyle(fontSize: 18),),
                  ),
                  ListTile(
                    title: Text("Total Price:"+"₹"+total_price.toString(),style: TextStyle(fontSize: 18),),
                    subtitle: Text("Quantity  :"+_quantity.toString()+"\n"
                        +"Order status  :"+order_status+"\n"+"Delivery option  :"+delevery_option,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  if(widget.paymentoption=="Online Payment")...[

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Card number',
                                hintText: 'Enter your card number',
                                prefixIcon: Icon(Icons.credit_card),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a card number';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                _cardNumber = value;
                              },
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Expiry date',
                                hintText: 'MM/YY',
                                prefixIcon: Icon(Icons.calendar_today),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter an expiry date';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                _expiryDate = value;
                              },
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'CVV',
                                hintText: 'Enter the 3-digit code on the back of your card',
                                prefixIcon: Icon(Icons.security),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a CVV';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                _cvv = value;
                              },
                            ),
                            SizedBox(height: 32.0),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: (){
                                  if (_formKey.currentState!.validate()) {
                                    startPayment();
                                  }
                                },
                                child: Text('Pay Now'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]else...[
                    SizedBox(
                      height: 100,
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Text("Send your money at the time of pickup from the shop",style: TextStyle(fontSize: 20),),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (){

                        },
                        child: Text('Complete Order'),
                      ),
                    ),
                  ]





                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
