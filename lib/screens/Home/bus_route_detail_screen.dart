// import 'package:flutter/material.dart';
// import 'package:busmap/models/Khanh/BusRoute/bus_route_detail.dart';
// import 'package:busmap/service/Khanh/bus_route_service.dart'; // Sửa import để dùng ApiService
//
// class BusRouteDetailScreen extends StatelessWidget {
//   final String routeId;
//
//   BusRouteDetailScreen({required this.routeId});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chi tiết tuyến xe'), backgroundColor: Colors.green,),
//       body: FutureBuilder<BusRouteDetail>(
//         future: BusRouteService().fetchBusRouteDetail(routeId), // Sửa để gọi fetchBusRouteDetail
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Lỗi: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
//           } else if (!snapshot.hasData) {
//             return const Center(child: Text('Không có dữ liệu'));
//           }
//
//           final routeDetail = snapshot.data!;
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Tên tuyến: ${routeDetail.routeName}',
//                   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   'Lộ trình lượt đi:',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 Text(routeDetail.inboundDescription),
//                 const SizedBox(height: 10),
//                 const Text(
//                   'Lộ trình lượt về:',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 Text(routeDetail.outboundDescription),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:busmap/models/Khanh/BusRoute/bus_route_detail.dart';
import 'package:busmap/service/Khanh/bus_route_service.dart';

class BusRouteDetailScreen extends StatelessWidget {
  final String routeId;

  const BusRouteDetailScreen({super.key, required this.routeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết tuyến xe'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<BusRouteDetail>(
        future: BusRouteService().fetchBusRouteDetail(routeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Lỗi: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Không có dữ liệu'));
          }

          final routeDetail = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Icon(Icons.directions_bus, size: 60, color: Colors.green.shade700),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    routeDetail.routeName,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.arrow_forward, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'Lộ trình lượt đi',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(routeDetail.inboundDescription),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.arrow_back, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              'Lộ trình lượt về',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(routeDetail.outboundDescription),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
