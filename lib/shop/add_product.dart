import 'package:echosentry/shop/shopmenu.dart';
import 'package:flutter/material.dart';


class AddProducts extends StatefulWidget {
  const AddProducts({Key? key}) : super(key: key);

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Add Products"),

      ),
      drawer: ShopMenu(menuindex: 2,),
    );
  }
}
