import 'package:flutter/material.dart';
import 'package:busmap/screens/admin/dashboard_screen.dart';
import 'package:busmap/screens/admin/ArticleListScreen.dart';
import 'package:busmap/screens/admin/TripHistoryScreen.dart';
import 'package:busmap/screens/admin/admin.dart';
import 'package:busmap/screens/admin/user_admin_chat_list_screen.dart';
import 'package:busmap/screens/admin/Bus_screen.dart';
 import 'package:busmap/screens/Login/welcome_screen.dart'; // Import WelcomeScreen
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({Key? key}) : super(key: key);

  // Hàm xử lý đăng xuất
  Future<void> _logout(BuildContext context) async {
    // Xóa dữ liệu trong SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Xóa toàn bộ dữ liệu (user_email, user_name, v.v.)

    // Chuyển hướng về WelcomeScreen và xóa stack điều hướng
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          (Route<dynamic> route) => false, // Xóa toàn bộ stack
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black, // Đổi màu nền của toàn bộ danh sách
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepOrangeAccent),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.departure_board_outlined, size: 40, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "BUS MAP",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
            // _buildMenuItem(context, Icons.dashboard, "Dashboard", const DashboardScreen()),
            _buildMenuItem(context, Icons.person, "Account Management", const AccountManagementScreen()),
            _buildMenuItem(context, Icons.history, "Account History", const TripHistoryScreen()),
            _buildMenuItem(context, Icons.add_card, "Advertising Information", ArticleScreen()),
            _buildMenuItem(context, Icons.add_card, "Bus Information", BusListScreen()),
            _buildMenuItem(context, Icons.add_card, "Chat List", UserAdminChatListScreen()),
            _buildMenuItem(context, Icons.logout, "Logout", null, isLogout: true),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, Widget? page, {bool isLogout = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue.shade900),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        onTap: () {
          if (isLogout) {
            // Xử lý đăng xuất
            Navigator.pop(context); // Đóng Drawer
            _logout(context); // Gọi hàm đăng xuất
          } else if (page != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          }
        },
      ),
    );
  }
}