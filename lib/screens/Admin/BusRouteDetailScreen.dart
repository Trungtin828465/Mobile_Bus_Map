// import 'package:flutter/material.dart';
// import 'package:busmap/models/Admin/BusRouteDetail.dart';
// import 'package:busmap/service/Admin/api_service.dart';
// class BusRouteDetailScreen extends StatelessWidget {
//   final String routeId;
//
//   BusRouteDetailScreen({required this.routeId});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//         title: Text('Chi tiết tuyến xe'),
//     leading: IconButton(
//     icon: Icon(Icons.arrow_back), // Biểu tượng mũi tên quay về
//     onPressed: () {
//     Navigator.pop(context); // Quay về màn hình trước đó (BusListScreen)
//     },
//     ),
//         ),
//       body: FutureBuilder<BusRouteDetail>(
//         future: ApiService().fetchBusRouteDetail(routeId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Lỗi: ${snapshot.error}'));
//           } else if (!snapshot.hasData) {
//             return Center(child: Text('Không có dữ liệu'));
//           }
//
//           final routeDetail = snapshot.data!;
//           return Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Tên tuyến: ${routeDetail.routeName}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 10),
//                 Text('Lộ trình lượt đi:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 Text(routeDetail.inboundDescription),
//                 SizedBox(height: 10),
//                 Text('Lộ trình lượt về:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
import 'package:busmap/models/Admin/BusRouteDetail.dart';
import 'package:busmap/service/Admin/api_service.dart';

class BusRouteDetailScreen extends StatelessWidget {
  final String routeId;

  const BusRouteDetailScreen({required this.routeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Màu nền AppBar đồng bộ với ứng dụng
        elevation: 0,
        title: const Text(
          'Chi tiết tuyến xe',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<BusRouteDetail>(
        future: ApiService().fetchBusRouteDetail(routeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 50,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Lỗi: ${snapshot.error}',
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Thử lại khi người dùng nhấn nút
                      (context as Element).markNeedsBuild();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Thử lại',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'Không có dữ liệu',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final routeDetail = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card chứa thông tin chính của tuyến xe
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.directions_bus,
                                color: Colors.green,
                                size: 30,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Tên tuyến: ${routeDetail.routeName}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Colors.grey,
                            thickness: 0.5,
                            height: 20,
                          ),
                          const Text(
                            'Thông tin lộ trình',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Lộ trình lượt đi
                          ListTile(
                            leading: const Icon(
                              Icons.arrow_forward,
                              color: Colors.blue,
                            ),
                            title: const Text(
                              'Lượt đi',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              routeDetail.inboundDescription,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Lộ trình lượt về
                          ListTile(
                            leading: const Icon(
                              Icons.arrow_back,
                              color: Colors.red,
                            ),
                            title: const Text(
                              'Lượt về',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              routeDetail.outboundDescription,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Nút để xem thêm thông tin (nếu cần)
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Thêm hành động nếu cần (ví dụ: xem bản đồ lộ trình)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tính năng đang phát triển')),
                        );
                      },
                      icon: const Icon(Icons.map),
                      label: const Text('Xem lộ trình trên bản đồ'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}