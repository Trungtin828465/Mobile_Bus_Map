import 'package:flutter/material.dart';

void main() {
  runApp(BusMapApp());
}

class BusMapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(()  // cập nhật ui khi click bottomNavigationBar
    {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: Icon(Icons.directions_bus),
        title: Row(
          children: [
            Text('Bus Map'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm địa điểm',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Container(
            height: 150,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
             // image: DecorationImage(
             //   image: AssetImage('img/bus.png'),
             //   fit: BoxFit.cover,
            //  ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              children: [
                _buildFeatureItem(Icons.directions_bus, 'Tra cứu'),
                _buildFeatureItem(Icons.route, 'Tìm đường'),
                _buildFeatureItem(Icons.location_on, 'Trạm xung quanh'),
                _buildFeatureItem(Icons.feedback, 'Góp ý'),
                _buildFeatureItem(Icons.school, 'Student Hub'),
                _buildFeatureItem(Icons.business, 'Buýt Doanh nghiệp'),
                _buildFeatureItem(Icons.directions_car, 'Tìm kiếm xe'),
                _buildFeatureItem(Icons.chat, 'Chat Nhóm'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.grey,  // Màu khi chưa chọn
        selectedItemColor: Colors.green,   // màu đã chọn
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Thông báo'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'Quét mã'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Yêu thích'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title) {
    return InkWell(
      onTap: () {
        print("$title được nhấn"); // Check onclick
      },
      splashColor: Colors.green.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12), // Bo icon
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.green.withOpacity(0.2),
            child: Icon(icon, color: Colors.green),
          ),
          SizedBox(height: 5),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
