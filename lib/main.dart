// import 'package:flutter/material.dart';
// import 'package:busmap/Router.dart';
// import 'package:busmap/service/http_override.dart'; // Import file override SSL
// import 'dart:io';
// import 'screens/RouterBusStop/DetailBus.dart';
// import 'screens/Login/welcome_screen.dart';
// import 'package:busmap/screens/RouterBusStop/SelectRoute.dart';
//
//
// void main() {
//   FluroRouterConfig.setupRouter(); // Quan trọng!
//   HttpOverrides.global = MyHttpOverrides(); // Kích hoạt bỏ qua SSL
//   runApp(BusMapApp());
// }
//
// class BusMapApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       onGenerateRoute: FluroRouterConfig.router.generator,
//       home: WelcomeScreen(),
//     );
//   }
// }
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
      home: const WelcomeScreen(), // hoặc HomeMaster nếu bạn muốn vào luôn
    );
  }
}


//
//
// import 'package:busmap/screens/Login/welcome_screen.dart';
// import 'package:busmap/service/Admin/user_admin_chat_service.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:busmap/providers/Khanh/favorite_provider.dart';
// import 'package:busmap/providers/user_admin_chat_provider.dart';
// import 'package:busmap/providers/Khanh/weather_provider.dart';
// import 'package:busmap/screens/Home/home_screen.dart';
// import 'package:busmap/screens/Notification/notification_screen.dart';
// import 'package:busmap/screens/Favorite/favorite_screen.dart';
// import 'package:busmap/screens/Home/list_chat_screen.dart';
// import 'package:busmap/screens/Home/bus_route_screen.dart';
// import 'package:busmap/screens/Home/user_chat_list_admin_screen.dart';
// import 'package:busmap/screens/Home/weather_forecast_screen.dart';
// import 'dart:io';
// import 'package:busmap/Router.dart';
// import 'package:busmap/service/http_override.dart';
// import 'package:busmap/screens/Home/GetAccount.dart';
// // Import file override SSL
//
// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
//   }
// }
//
// void main() {
//   HttpOverrides.global = MyHttpOverrides();
//   FluroRouterConfig.setupRouter(); // Quan trọng!
// //   HttpOverrides.global = MyHttpOverrides(); // Kích hoạt bỏ qua SSL
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => FavoriteProvider()),
//         ChangeNotifierProvider(create: (_) => ChatProvider()),
//         ChangeNotifierProvider(create: (_) => WeatherProvider()),
//       ],
//       child: const BusMapApp(),
//     ),
//   );
// }
//
// class BusMapApp extends StatelessWidget {
//   const BusMapApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Bus Map',
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       debugShowCheckedModeBanner: false,
//      // debugShowCheckedModeBanner: false,
//   onGenerateRoute: FluroRouterConfig.router.generator,
//       home:  HomeScreen(),
//       routes: {
//         '/list_chat': (context) => ListChatScreen(),
//         '/bus_route': (context) => const BusRouteScreen(),
//         '/user_admin_chat_list': (context) => UserChatUserListScreen(),
//         '/weather': (context) => const WeatherForecastScreen(),
//       },
//     );
//   }
// }
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//
//   final List<Widget> _screens = [
//     const HomeContent(),
//     NotificationScreen(),
//     const Center(child: Text('Quét mã')),
//     const FavoriteScreen(),
//      EditProfileScreen(),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: _screens,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         unselectedItemColor: Colors.grey,
//         selectedItemColor: Colors.green,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
//           BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Thông báo'),
//           BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'Quét mã'),
//           BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Yêu thích'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản1'),
//         ],
//       ),
//     );
//   }
// }