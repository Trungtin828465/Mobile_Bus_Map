// import 'package:busmap/screens/Dung/FindWay.dart';
// import 'package:flutter/material.dart';
// import 'package:busmap/screens/Home/list_chat_screen.dart'; // Import ListChatScreen
// import 'package:busmap/screens/Home/bus_route_screen.dart'; // Import BusRouteScreen
// import 'package:busmap/screens/Home/user_chat_list_admin_screen.dart'; // Import UserAdminChatListScreen
// import 'package:busmap/screens/Home/weather_forecast_screen.dart'; // Import WeatherForecastScreen
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:busmap/Router.dart';
// import 'package:busmap/screens/RouterBusStop/MapGpsSearch.dart';
// import 'package:busmap/screens/Map/MapGps.dart';
// import 'package:busmap/screens/Login/welcome_screen.dart';
//
//
// class HomeContent extends StatefulWidget {
//   const HomeContent({super.key});
//
//   @override
//   _HomeContentState createState() => _HomeContentState();
// }
//
// class _HomeContentState extends State<HomeContent> {
//   String? userEmail;
//   int? userId;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadEmail();
//   }
//
//
//   Future<void> _loadEmail() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     int? id = prefs.getInt('user_id');
//     String? email = prefs.getString('user_email');
//
//     print('user_id lấy được trong HomeContent: $id');
//     print('user_email lấy được trong HomeContent: $email');
//
//     setState(() {
//       userId = id;
//       userEmail = email ?? 'Không có email';
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         elevation: 0,
//         leading: const Icon(Icons.directions_bus),
//         title: const Row(
//           children: [
//             Text('Bus Map'),
//           ],
//         ),
//       ),
//
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               "ID user :  $userId",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: 'Tìm kiếm địa điểm',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 filled: true,
//                 fillColor: Colors.white,
//               ),
//             ),
//           ),
//           // Bản đồ GPS
//           SizedBox(
//             width: 400,
//             height: 300,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.blue, width: 2.0),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: MapGps(),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: GridView.count(
//               crossAxisCount: 4,
//               children: [
//                 _buildFeatureItem(Icons.directions_bus, 'Tra cứu', isBusRoute: true),
//                 _buildFeatureItem(Icons.route, 'Tìm đường',isFindWay: true),
//                 _buildFeatureItem(Icons.location_on, 'Trạm xung quanh',mapSearch:true),
//                 _buildFeatureItem(Icons.feedback, 'Admin Chat', isAdminChat: true),
//                 _buildFeatureItem(Icons.school, 'Weather', isWeather: true), // Thêm isWeather
//                 // _buildFeatureItem(Icons.business, 'Buýt Doanh nghiệp'),
//                // _buildFeatureItem(Icons.directions_car, 'Tìm kiếm xe', isVehicleSearch: true),
//                 _buildFeatureItem(Icons.chat, 'ChatBot', isChat: true),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFeatureItem(IconData icon, String title,
//       {
//         // bool isVehicleSearch = false,
//         bool isChat = false,
//         bool isBusRoute = false,
//         bool isAdminChat = false,
//         bool isWeather = false,
//         bool isFindWay = false,
//         bool mapSearch = false}) { // Thêm tham số isWeather
//     return InkWell(
//       onTap: () {
//         print("$title được nhấn");
//         if (isBusRoute) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const BusRouteScreen()),
//           );
//         } else if (isChat) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => ListChatScreen()),
//           );
//         } else if (isAdminChat) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => UserChatUserListScreen()),
//           );
//         } else if (isWeather) { // Thêm điều hướng cho Weather
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => const WeatherForecastScreen()),
//           );
//         }else if (isFindWay) { // Thêm điều hướng cho Weather
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) =>  FindWay()),
//           );
//         }
//         else if (mapSearch) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) =>  MapGpsSearch()),
//           );
//         }
//       },
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircleAvatar(
//             backgroundColor: Colors.green.withOpacity(0.2),
//             child: Icon(icon, color: Colors.green),
//           ),
//           const SizedBox(height: 5),
//           Text(title, textAlign: TextAlign.center),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:busmap/screens/Home/list_chat_screen.dart';
import 'package:busmap/screens/Home/bus_route_screen.dart';
import 'package:busmap/screens/Home/user_chat_list_admin_screen.dart';
import 'package:busmap/screens/Home/weather_forecast_screen.dart';
import 'package:busmap/screens/Map/MapGps.dart';
import 'package:busmap/screens/Dung/FindWay.dart';
import 'package:busmap/screens/RouterBusStop/MapGpsSearch.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String? userEmail;
  int? userId;
  String? fullName;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('user_id');
      userEmail = prefs.getString('user_email') ?? 'Không có email';
      fullName = prefs.getString('user_name') ?? 'Không có fullname';
    });

    print('user_id trong HomeContent: $userId');
    print('user_email trong HomeContent: $userEmail');
    print('full_name trong HomeContent: $fullName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(

        backgroundColor: Colors.green,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.directions_bus, color: Colors.white),
            SizedBox(width: 8),
            Text('Bus Map'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Hiển thị thông tin người dùng
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "👤 Xin chào: $fullName",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),

          // Ô tìm kiếm
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: '🔍 Tìm kiếm địa điểm',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Bản đồ GPS
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              height: 250,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:  MapGps(),
                ),
              ),
            ),
          ),

          // Grid các chức năng
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: _features.map((feature) => _buildFeatureItem(feature)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(_FeatureItem item) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => item.page),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.green.withOpacity(0.2),
            radius: 28,
            child: Icon(item.icon, color: Colors.green, size: 28),
          ),
          const SizedBox(height: 8),
          Text(item.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

// Danh sách chức năng chính
final List<_FeatureItem> _features = [
  _FeatureItem(icon: Icons.directions_bus, title: 'Tra cứu', page: const BusRouteScreen()),
  _FeatureItem(icon: Icons.route, title: 'Tìm đường', page: FindWay()),
  _FeatureItem(icon: Icons.location_on, title: 'Trạm gần bạn', page: MapGpsSearch()),
  _FeatureItem(icon: Icons.feedback, title: 'Admin Chat', page: UserChatUserListScreen()),
  _FeatureItem(icon: Icons.school, title: 'Thời tiết', page: const WeatherForecastScreen()),
  _FeatureItem(icon: Icons.chat, title: 'ChatBot', page: ListChatScreen()),
];

// Class đại diện cho từng chức năng
class _FeatureItem {
  final IconData icon;
  final String title;
  final Widget page;

  _FeatureItem({required this.icon, required this.title, required this.page});
}
