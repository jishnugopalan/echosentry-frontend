import 'package:flutter/material.dart';
class LandHolderDashboard extends StatefulWidget {
  const LandHolderDashboard({Key? key}) : super(key: key);

  @override
  State<LandHolderDashboard> createState() => _LandHolderDashboardState();
}

class _LandHolderDashboardState extends State<LandHolderDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
    );
  }
}
