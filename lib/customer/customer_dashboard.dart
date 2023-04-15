import 'package:dio/dio.dart';
import 'package:echosentry/customer/customermenu.dart';
import 'package:echosentry/customer/subcategory.dart';
import 'package:flutter/material.dart';

import '../services/addproduct_service.dart';
class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({Key? key}) : super(key: key);

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {

  //final TextEditingController _searchController = TextEditingController();

  //static const List<Widget> _menuOptions = <Widget>[    Text('Design'),    Text('Projects'),    Text('Favorites'),    Text('Settings'),  ];
  List<String> items = [];
  AddProductService service=AddProductService();
  late final Response? response;
  Future<void>getCategory()async{
    try{
      response=await service.getAllCategory();
      print(response!.data);
      final jsonData = response!.data;

      for(int i=0;i<jsonData.length;i++){

        setState(() {
          items.add(jsonData[i]["category"]);
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
  gotoSubCategory(index){
    final jsonData = response!.data;
    print(jsonData[index]["_id"]);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SubcategoryPage(categoryid: jsonData[index]["_id"]),
      ),
    );
    print(index);
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
    super.initState();
    getCategory();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AgriGrew '),

      ),
      drawer:CustomerMenu(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          //   child: Text(
          //     'Discover',
          //     style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       fontSize: 24.0,
          //     ),
          //   ),
          // ),
          // Container(
          //   height: 200.0,
          //   child: ListView(
          //     scrollDirection: Axis.horizontal,
          //     padding: EdgeInsets.all(10),
          //     children: <Widget>[
          //       Card(
          //         child: Container(
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(10),
          //               color: Colors.grey[300],
          //             ),
          //             width: 200,
          //             alignment: Alignment.center,
          //
          //
          //             child: Container(
          //               child: Column(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   Icon(Icons.landscape_sharp,size: 50,),
          //                   Text("LAND"),
          //                 ],
          //               ),
          //             )
          //         ),
          //       ),
          //       SizedBox(
          //         width: 10,
          //       ),
          //       Card(
          //         child: Container(
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(10),
          //               color: Colors.grey[300],
          //             ),
          //             width: 200,
          //             alignment: Alignment.center,
          //
          //             child: Container(
          //               child: Column(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   Icon(Icons.agriculture,size: 50,),
          //                   Text("VEHICLE"),
          //                 ],
          //               ),
          //             )
          //         ),
          //       ),
          //       SizedBox(
          //         width: 10,
          //       ),
          //       Card(
          //         child: Container(
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(10),
          //               color: Colors.grey[300],
          //             ),
          //             width: 200,
          //             alignment: Alignment.center,
          //
          //             child: Container(
          //               child: Column(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   Icon(Icons.home_work,size: 50,),
          //                   Text("PLANT NURSERY"),
          //                 ],
          //               ),
          //             )
          //         ),
          //       ),
          //       SizedBox(
          //         width: 10,
          //       ),
          //
          //
          //     ],
          //
          //   ),
          // ),

          Container(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Text(
              'Explore',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
          ),
          // Container(
          //   // Add padding around the search bar
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
              ),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
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
                    gotoSubCategory(index);
                    // Navigator.pushNamed(context, '/subcategory');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
