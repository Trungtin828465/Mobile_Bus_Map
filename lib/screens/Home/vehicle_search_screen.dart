import 'package:flutter/material.dart';
import '../../widgets/route_item_widget.dart'; // Import file mới

class VehicleSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context); // Quay lại trang trước
          },
        ),
        title: Text('Vehicle Search', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter vehicle number or route',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    // Xóa nội dung tìm kiếm (nếu cần)
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                RouteItemWidget(
                  routeNumber: '70H-049.84',
                  routeName: 'Route 70-1: Cu Chi Bus Station - Tay Ninh Bus Station',
                  time: '',
                  price: '',
                  rating: '',
                ),
                // Thêm các tuyến khác nếu cần
              ],
            ),
          ),
        ],
      ),
    );
  }
}