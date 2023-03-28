import 'package:echosentry/shop/shopmenu.dart';
import 'package:flutter/material.dart';


class ShopDashboard extends StatefulWidget {
  const ShopDashboard({Key? key}) : super(key: key);

  @override
  State<ShopDashboard> createState() => _ShopDashboardState();
}

class _ShopDashboardState extends State<ShopDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),

      ),
      drawer: ShopMenu(menuindex: 1,),

    );
  }
}
