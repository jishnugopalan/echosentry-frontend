import 'package:dio/dio.dart';
import 'package:echosentry/services/view_order_service.dart';
import 'package:echosentry/shop/shopmenu.dart';
import 'package:echosentry/shop/vieworderdetails.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class ViewOrderVendor extends StatefulWidget {
  const ViewOrderVendor({Key? key}) : super(key: key);

  @override
  State<ViewOrderVendor> createState() => _ViewOrderVendorState();
}

class _ViewOrderVendorState extends State<ViewOrderVendor> {
  // final storage = const FlutterSecureStorage();
  ViewOrderService service=ViewOrderService();
  List<dynamic> data = [];
  getOrders() async {

    try {
      final Response? response = await service.viewOrderByVendorId();

      final jsonData = response!.data as List<dynamic>;
      print(jsonData);
      setState(() {
        data = jsonData;
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
  gotoPaymentPage(orderid){

    print(orderid);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ViewOrderDetails(orderid: orderid),
      ),
    );
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrders();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      drawer: ShopMenu(menuindex: 3,),
      body: ListView.builder(
        itemCount: data.length,
        padding: EdgeInsets.all(10),

        itemBuilder: (BuildContext context, int index) {
          // String productname="";
          // productname=data[index]['productname'];
          DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(int.parse(data[index]['timestamp']) * 1000);
          String formattedDate = DateFormat.yMd().add_Hms().add_jm().format(dateTime);
          print(formattedDate);


          return ListTile(


            title: Text(data[index]["product"]["productname"] ?? "ggg",style: TextStyle(fontWeight: FontWeight.w600,fontSize:20,color: Colors.green[800]),),
            subtitle: Text("₹"+data[index]['total_price'].toString()+"\n"+data[index]['order_status']+"\n"+formattedDate,style: TextStyle(fontSize: 16),),
            trailing: Icon(Icons.shopping_bag,color: Colors.blue,),
            onTap: (){
              gotoPaymentPage(data[index]["_id"]);
            },
            tileColor: data[index]['order_status']=="Payment Completed"?Colors.greenAccent[100]:Colors.grey[100]
          );
        },
      ),
    );
  }
}
