import 'package:echosentry/admin/add_adviser.dart';
import 'package:echosentry/admin/admin_menu.dart';
import 'package:flutter/material.dart';


class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),

      ),
      drawer: AdminMenu(),
      body:  GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300],
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),

              child: Text("Add Adviser",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
            ),
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddAdviser(),
                ),
              );
            },
          ),
          // GestureDetector(
          //   child: Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(10),
          //       color: Colors.grey[300],
          //     ),
          //     alignment: Alignment.center,
          //     padding: const EdgeInsets.all(8),
          //
          //     child: Text("View Advisers",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
          //   ),
          // ),


        ],
      )
    );
  }
}
