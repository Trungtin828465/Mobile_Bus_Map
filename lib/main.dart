// import 'package:flutter/material.dart';
// import 'package:project1/app/features/dashboard/screens/dashboard_screen.dart';
// import 'package:project1/app/features/dashboard/screens/TripHistoryScreen.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Admin Dashboard',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home:  DashboardScreen(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'package:project1/app/features/dashboard/screens/Signin.dart';
import 'package:project1/app/features/dashboard/screens/dashboard_screen.dart';
import 'package:project1/app/features/dashboard/screens/Welcome_Admin.dart';
import 'package:project1/app/providers/user_admin_chat_provider.dart'; // Import ChatProvider
import 'package:project1/app/features/dashboard/screens/acount_management.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatProvider>(
      create: (context) => ChatProvider(), // Tạo instance của ChatProvider
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Admin Dashboard',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const WelcomeScreen(), // Bắt đầu từ WelcomeScreen
        routes: {
          '/dashboard': (context) => const AccountManagementScreen(),
          '/signin': (context) => const SignInScreen(),
        },
      ),
    );
  }
}