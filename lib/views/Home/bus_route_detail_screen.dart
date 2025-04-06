import 'package:flutter/material.dart';
import 'package:busmap/models/BusRoute/bus_route_detail.dart';
import 'package:busmap/services/bus_route_service.dart'; // Sửa import để dùng ApiService

class BusRouteDetailScreen extends StatelessWidget {
  final String routeId;

  BusRouteDetailScreen({required this.routeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết tuyến xe'), backgroundColor: Colors.green,),
      body: FutureBuilder<BusRouteDetail>(
        future: BusRouteService().fetchBusRouteDetail(routeId), // Sửa để gọi fetchBusRouteDetail
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Không có dữ liệu'));
          }

          final routeDetail = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tên tuyến: ${routeDetail.routeName}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Lộ trình lượt đi:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(routeDetail.inboundDescription),
                const SizedBox(height: 10),
                const Text(
                  'Lộ trình lượt về:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(routeDetail.outboundDescription),
              ],
            ),
          );
        },
      ),
    );
  }
}