import 'package:dio/dio.dart';
import 'package:echosentry/customer/customermenu.dart';
import 'package:echosentry/customer/products.dart';
import 'package:flutter/material.dart';

import '../services/addproduct_service.dart';
class SubcategoryPage extends StatefulWidget {
  const SubcategoryPage({Key? key, required this.categoryid}) : super(key: key);
  final String categoryid;

  @override
  State<SubcategoryPage> createState() => _SubcategoryPageState();
}

class _SubcategoryPageState extends State<SubcategoryPage> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  late final Response? response2;
  AddProductService service=AddProductService();
  static const List<Widget> _menuOptions = <Widget>[    Text('Design'),    Text('Projects'),    Text('Favorites'),    Text('Settings'),  ];
  List<String> items = [];
  void _onMenuOptionTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  getSubCategory() async {
    try{
      response2=await service.getSubCategory(widget.categoryid);
      print(response2!.data);
      final jsonData2 = response2!.data;
      // subcategory.clear();
      for(int i=0;i<jsonData2.length;i++){

        setState(() {
          items.add(jsonData2[i]["subcategory"]);
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
  gotoProducts(index){
    final jsonData = response2!.data;
    print(jsonData[index]["_id"]);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductPage(subcategoryid: jsonData[index]["_id"]),
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
    print(widget.categoryid);
    getSubCategory();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Subcategories'),

        ),
        drawer: CustomerMenu(),

        body:
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: items.length,
                  padding: EdgeInsets.all(10),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child:
                      Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.greenAccent[100],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            SizedBox(height: 8.0),
                            Text(
                              items[index],
                              textAlign: TextAlign.center,

                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,

                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: (){
                        gotoProducts(index);
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