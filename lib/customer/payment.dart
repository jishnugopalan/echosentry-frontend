import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:echosentry/customer/startpayment.dart';
import 'package:flutter/material.dart';

import '../services/view_product_service.dart';
import 'customermenu.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key, required this.orderid}) : super(key: key);
  final String orderid;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.orderid);
    getPoductDetails();
  }
  String image="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAMgAAADICAMAAACahl6sAAAC91BMVEVHcEwAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cAe8cCb+BgAAAA/HRSTlMA5ZgNzH24vZkLA/75Av31+PwE6gEHLTIWCvsi9g+wOgXR+hOTJs/3DuxPm0wYDNrzXfI8te3pbxT0EeAIKxnnZkcbwFhDjxwG2Tcs8eHoi5pX4kF5y3Nn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";
  getPoductDetails() async {
    try{
      response2=await service.viewOrderByOrderid(widget.orderid);
      print(response2!.data);
      setState(() {
        product_name=response2!.data["product"]["productname"];
        // category=response2!.data["product"]["category"]["category"];
        // subcategory=response2!.data["product"]["subcategory"]["subcategory"];
        image=response2!.data["product"]["image"];
        description=response2!.data["product"]["description"];
        price=response2!.data["product"]["price"];
        stock=response2!.data["product"]["stock"];
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
  gotoPay(){
    print("Order id"+response2!.data["_id"]);
    print("product id"+response2!.data["product"]["_id"]);
    print("Vendor id"+response2!.data["vendorid"]);
    print(payment_option);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StartPaymentPage(orderid:response2!.data["_id"], productid: response2!.data["product"]["_id"], vendorid: response2!.data["vendorid"], paymentoption: payment_option,),
      ),
    );


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Order'),

      ),
      drawer: CustomerMenu(),

      body: ListView(

        children: [
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(

                  child:
                  Text(
                    product_name,
                    style: TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  alignment: Alignment.topLeft,
                ),

                Image.memory(
                  base64Decode(image.split(',')[1]),
                  fit: BoxFit.contain,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Icon(Icons.image);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(height: 8),
                      Text(
                        '₹'+price.toString(),
                        style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                            fontSize: 16),
                      ),





                    ],
                  ),
                ),
              ],
            ),
          ),
          Card(

            child: Container(
              padding: EdgeInsets.only(left: 5,top: 20,bottom: 20),
              alignment: Alignment.topLeft,

              child: Column(

                children: [
                  ListTile(
                    title: Text("Total Price:"+"₹"+total_price.toString(),style: TextStyle(fontSize: 18),),
                    subtitle: Text("Quantity  :"+_quantity.toString()+"\n"
                        +"Order status  :"+order_status+"\n"+"Delivery option  :"+delevery_option,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),

                ],
              ),
            ),
          ),
          if(order_status=="Payment Completed")...[

          ]
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child:order_status!="Payment Completed"? Container(
          //  alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ElevatedButton(
              //   onPressed: () {
              //     // Add to cart logic
              //   },
              //   child: Text('Add to Cart'),
              // ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      String contentText = "Content of Dialog";
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            title: Text('Payment Options'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                SizedBox(height: 16),

                                Text("Please select the payment option"),
                                if(delevery_option=="Pick up from shop")...[
                                  RadioListTile(
                                    title: Text("Online Payment"),
                                    value: "Online Payment",

                                    groupValue: payment_option,

                                    onChanged: (value){
                                      setState(() {
                                        payment_option = value.toString();
                                      });
                                    },

                                  ),

                                  RadioListTile(
                                    title: Text("Pay at shop"),
                                    value: "Pay at shop",
                                    groupValue: payment_option,
                                    onChanged: (value){
                                      setState(() {
                                        payment_option = value.toString();
                                      });
                                    },
                                  ),
                                ]else...[
                                  RadioListTile(
                                    title: Text("Online Payment"),
                                    value: "Online Payment",

                                    groupValue: payment_option,

                                    onChanged: (value){
                                      setState(() {
                                        payment_option = value.toString();
                                      });
                                    },

                                  ),
                                ]

                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  gotoPay();
                                },
                                child: Text('Pay Now'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
                child: Text('Pay Now'),
              ),
            ],
          ),
        ):Container(
          // alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Text("Payment Completed",style: TextStyle(color: Colors.blue,fontSize: 18,),),
              )
            ],
          )
        ),
      ),


    );
  }
}
