
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:busmap/providers/Khanh/favorite_provider.dart';
import 'package:busmap/providers/user_admin_chat_provider.dart';
import 'package:busmap/providers/Khanh/weather_provider.dart';
import 'package:busmap/Router.dart';
import 'package:busmap/service/http_override.dart'; // SSL override
import 'dart:io';
import 'screens/Home/HomeMasterScreen.dart';
import 'screens/Login/welcome_screen.dart';

void main() {
  FluroRouterConfig.setupRouter(); // cấu hình Fluro
  HttpOverrides.global = MyHttpOverrides(); // override SSL
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: const BusMapApp(),
    ),
  );
}

class BusMapApp extends StatelessWidget {
  const BusMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: FluroRouterConfig.router.generator,
     // home: const HomeMaster(), // hoặc HomeMaster nếu bạn muốn vào luôn
      home:  const WelcomeScreen(), // hoặc HomeMaster nếu bạn muốn vào luôn

    );
  }
}
