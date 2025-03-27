import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:busmap/providers/favorite_provider.dart';
import 'package:busmap/providers/user_admin_chat_provider.dart'; // Đổi tên ChatProvider thành UserAdminChatProvider
import 'package:busmap/providers/weather_provider.dart'; // Thêm WeatherProvider
import 'package:busmap/screens/Home/home_screen.dart';
import 'package:busmap/screens/Notification/notification_screen.dart';
import 'package:busmap/screens/Favorite/favorite_screen.dart';
import 'package:busmap/screens/Home/vehicle_search_screen.dart';
import 'package:busmap/screens/Home/list_chat_screen.dart';
import 'package:busmap/screens/Home/bus_route_screen.dart';
import 'package:busmap/screens/Home/user_admin_chat_list_screen.dart';
import 'package:busmap/screens/Home/weather_forecast_screen.dart'; // Thêm WeatherForecastScreen
import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => UserAdminChatProvider()), // Đổi tên ChatProvider
        ChangeNotifierProvider(create: (_) => WeatherProvider()), // Thêm WeatherProvider
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
      title: 'Bus Map',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: true,
      home: const HomeScreen(),
      routes: {
        '/vehicle_search': (context) => VehicleSearchScreen(),
        '/list_chat': (context) => ListChatScreen(),
        '/bus_route': (context) => const BusRouteScreen(),
        '/user_admin_chat_list': (context) => UserAdminChatListScreen(),
        '/weather': (context) => const WeatherForecastScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    NotificationScreen(),
    const Center(child: Text('Quét mã')),
    const FavoriteScreen(),
    const Center(child: Text('Tài khoản')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.green,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Thông báo'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'Quét mã'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Yêu thích'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
        ],
      ),
    );
  }
}