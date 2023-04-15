import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:echosentry/customer/customermenu.dart';
import 'package:echosentry/customer/viewproduct.dart';
import 'package:echosentry/services/view_product_service.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key, required this.subcategoryid}) : super(key: key);
  final String subcategoryid;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  late final Response? response2;
  ViewProduct service=ViewProduct();
  late final String json;
  static const List<Widget> _menuOptions = <Widget>[    Text('Design'),    Text('Projects'),    Text('Favorites'),    Text('Settings'),  ];
  List<Item> _items=[];
  void _onMenuOptionTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  getProducts() async {
    try{
      response2=await service.getProductBySubcategory(widget.subcategoryid);
      print(response2!.data);
      final json = response2!.data as List<dynamic>;
      setState(() {
        _items = json.map((e) => Item.fromJson(e as Map<String, dynamic>)).toList();
      });
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

  getProductDetails(index){
    print(index);
    final jsonData = response2!.data;
    print(jsonData[index]["_id"]);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ViewProductPage(productid: jsonData[index]["_id"]),
      ),
    );
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
    super.initState();
    print(widget.subcategoryid);
    getProducts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Products'),

        ),
        drawer: CustomerMenu(),

        body:
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Container(
              //   // Add padding around the search bar
              //   padding: const EdgeInsets.all(10),
              //
              //
              //   // Use a Material design search bar
              //   child: TextField(
              //     controller: _searchController,
              //     decoration: InputDecoration(
              //       hintText: 'Search...',
              //       // Add a clear button to the search bar
              //       suffixIcon: IconButton(
              //         icon: Icon(Icons.clear),
              //         onPressed: () => _searchController.clear(),
              //       ),
              //       // Add a search icon or button to the search bar
              //       prefixIcon: IconButton(
              //         icon: Icon(Icons.search),
              //         onPressed: () {
              //           // Perform the search here
              //         },
              //       ),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(20.0),
              //       ),
              //     ),
              //   ),
              // ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10
                  ),
                  padding: EdgeInsets.all(10),

                  itemCount: _items.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = _items[index];
                    return GestureDetector(

                      child: Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.greenAccent[100],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            // SizedBox(height: 8.0),
                            Container(
                              height: 100,
                              width: 100,

                              child: Image.memory(
                                base64Decode(item.image.split(',')[1]),
                                fit: BoxFit.cover,



                              ),
                            ),
                            Text(
                              item.name,
                              textAlign: TextAlign.center,

                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,

                              ),
                            ),
                            Text("₹"+item.price.toString())
                          ],
                        ),
                      ),
                      onTap: (){
                        getProductDetails(index);
                       // Navigator.pushNamed(context, '/productview');
                      },
                    );


                  },
                ),
              ),
            ]

        )



    );


  }
}
class Item {
  final String name;
  final int price;
  final String image;
  Item({required this.name, required this.price, required this.image, });
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['productname'],
      price: json['price'],
      image: json['image']

    );
  }
}