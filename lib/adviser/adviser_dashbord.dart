import 'package:flutter/material.dart';

import 'adviser_menu.dart';


class AdviserDashboard extends StatefulWidget {
  const AdviserDashboard({Key? key}) : super(key: key);

  @override
  State<AdviserDashboard> createState() => _AdviserDashboardState();
}

class _AdviserDashboardState extends State<AdviserDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      drawer: AdviserMenu(),
    );
  }
}
