import 'package:flutter/material.dart';
import 'package:utilitybus/views/map_screen.dart';

import 'package:utilitybus/routes/route_app.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: FluroRouterConfig.router.generator,
      home: MapScreen(),
    );
  }
}