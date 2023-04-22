import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class AdminMenu extends StatefulWidget {
  const AdminMenu({Key? key}) : super(key: key);

  @override
  State<AdminMenu> createState() => _AdminMenuState();
}

class _AdminMenuState extends State<AdminMenu> {
  final storage = FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(

            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/EcoSentry-Logo2.png'))), child: null,
          ),
          Container(
            alignment: Alignment.center,
            child: Text("Build Your Online Shop",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
          ),
          ListTile(
            leading: Icon(Icons.home,),
            title: listtileText("Home"),
            onTap: () => {
              Navigator.pushNamed(context, '/admindashboard')
            },
            //selected: isHome,
            selectedTileColor: Colors.black12,
            selectedColor: Colors.green[800],

          ),
          ListTile(
            leading: Icon(Icons.account_circle_sharp,),
            title: listtileText("Add adviser"),
            onTap: () => {
              Navigator.pushNamed(context, '/addadviser')
            },
            //selected: isHome,
            selectedTileColor: Colors.black12,
            selectedColor: Colors.green[800],

          ),

          ListTile(
            leading: Icon(Icons.logout,),
            title: listtileText("Logout"),
            onTap: () async {

              await storage.delete(key: "token");
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);

            },


            selectedColor: Colors.green[800],

          ),


        ],
      ),

    );
  }

  Widget listtileText(String txt){
    return Text(txt,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 21),);
  }
}
