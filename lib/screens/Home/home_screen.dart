import 'package:flutter/material.dart';
import 'package:busmap/screens/Home/list_chat_screen.dart'; // Import ListChatScreen
import 'package:busmap/screens/Home/bus_route_screen.dart'; // Import BusRouteScreen
import 'package:busmap/screens/Home/user_admin_chat_list_screen.dart'; // Import UserAdminChatListScreen
import 'package:busmap/screens/Home/weather_forecast_screen.dart'; // Import WeatherForecastScreen

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: const Icon(Icons.directions_bus),
        title: const Row(
          children: [
            Text('Bus Map'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm địa điểm',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              children: [
                _buildFeatureItem(Icons.directions_bus, 'Tra cứu', isBusRoute: true),
                _buildFeatureItem(Icons.route, 'Tìm đường'),
                _buildFeatureItem(Icons.location_on, 'Trạm xung quanh'),
                _buildFeatureItem(Icons.feedback, 'Admin Chat', isAdminChat: true),
                _buildFeatureItem(Icons.school, 'Weather', isWeather: true), // Thêm isWeather
                _buildFeatureItem(Icons.business, 'Buýt Doanh nghiệp'),
                _buildFeatureItem(Icons.directions_car, 'Tìm kiếm xe', isVehicleSearch: true),
                _buildFeatureItem(Icons.chat, 'ChatBot', isChat: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title,
      {bool isVehicleSearch = false,
        bool isChat = false,
        bool isBusRoute = false,
        bool isAdminChat = false,
        bool isWeather = false}) { // Thêm tham số isWeather
    return InkWell(
      onTap: () {
        print("$title được nhấn");
        if (isBusRoute) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BusRouteScreen()),
          );
        } else if (isChat) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ListChatScreen()),
          );
        } else if (isAdminChat) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserAdminChatListScreen()),
          );
        } else if (isWeather) { // Thêm điều hướng cho Weather
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WeatherForecastScreen()),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.green.withOpacity(0.2),
            child: Icon(icon, color: Colors.green),
          ),
          const SizedBox(height: 5),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}