import 'package:flutter/material.dart';
import 'app.dart';
import 'package:utilitybus/routes/route_app.dart';

void main() {
  FluroRouterConfig.defineRoutes();
  runApp(MyApp());
}