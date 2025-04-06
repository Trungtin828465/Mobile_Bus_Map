import 'package:flutter/material.dart';

class BusRouteMapPage extends StatelessWidget {
  final Map<String, dynamic> routeData;

  const BusRouteMapPage({Key? key, required this.routeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bus Route Map")),
      body: Center(
        child: Text("Map for route: ${routeData["Title"]}"),
      ),
    );
  }
}