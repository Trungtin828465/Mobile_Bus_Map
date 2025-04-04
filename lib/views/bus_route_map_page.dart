import 'package:flutter/material.dart';

class BusRouteMapPage extends StatelessWidget {
  final List<dynamic> routeStops;

  BusRouteMapPage({required this.routeStops});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bus Route Map")),
      body: Center(
        child: Text("Map with stops: ${routeStops.toString()}"),
      ),
    );
  }
}