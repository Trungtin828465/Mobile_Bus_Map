import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:busmap/providers/Khanh/favorite_provider.dart';
import 'package:busmap/providers/user_admin_chat_provider.dart';
import 'package:busmap/providers/Khanh/weather_provider.dart';
import 'package:busmap/screens/Home/home_screen.dart';
import 'package:busmap/screens/Notification/notification_screen.dart';
import 'package:busmap/screens/Favorite/favorite_screen.dart';
import 'package:busmap/screens/Home/list_chat_screen.dart';
import 'package:busmap/screens/Home/bus_route_screen.dart';
import 'package:busmap/screens/Home/user_chat_list_admin_screen.dart';
import 'package:busmap/screens/Home/weather_forecast_screen.dart';
import 'package:busmap/screens/Home/GetAccount.dart';

class HomeMaster extends StatefulWidget {
  const HomeMaster({super.key});

  @override
  _HomeMasterState createState() => _HomeMasterState();
}

class _HomeMasterState extends State<HomeMaster> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    NotificationScreen(),
    const Center(child: Text('Quét mã')),
    const FavoriteScreen(),
    EditProfileScreen(),
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
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản1'),
          ],
        ),

    );
  }
}