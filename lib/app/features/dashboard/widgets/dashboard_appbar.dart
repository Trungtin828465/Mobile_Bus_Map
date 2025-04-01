import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const DashboardAppBar({Key? key, required this.scaffoldKey}) : super(key: key);

  // Hàm lấy email từ SharedPreferences
  Future<String> _getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name') ?? 'Người dùng'; // Giá trị mặc định nếu không có email
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.teal[300],
      elevation: 2, // Đổ bóng nhẹ
      title: Row(
        children: const [
          Icon(Icons.departure_board_outlined, size: 30, color: Colors.amber),
          SizedBox(width: 10), // Khoảng cách giữa icon và text
          Text(
            "BUS MAP",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
          ),
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => scaffoldKey.currentState?.openDrawer(),
      ),
      actions: [
        // Dùng FutureBuilder để lấy email và hiển thị
        FutureBuilder<String>(
          future: _getUserEmail(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: CircularProgressIndicator(
                  color: Colors.amber,
                  strokeWidth: 2,
                ),
              );
            } else if (snapshot.hasError) {
              return const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Text(
                  'Lỗi',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            } else {
              // Hiển thị email người dùng
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: Text(
                    snapshot.data ?? 'Người dùng',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}