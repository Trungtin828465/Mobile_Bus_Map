// // import 'package:flutter/material.dart';
// // import 'package:busmap/widgets//notification_item.dart';
// // import 'article_list_screen.dart';
// //
// // class NotificationScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return DefaultTabController(
// //       length: 2,
// //       child: Scaffold(
// //         appBar: AppBar(
// //           title: const Text(
// //             'Tin tức và thông báo',
// //             style: TextStyle(color: Colors.white),
// //           ),
// //           backgroundColor: Colors.green,
// //           elevation: 0,
// //           bottom: const TabBar(
// //             tabs: [
// //               Tab(text: 'Tin tức'),
// //               Tab(text: 'Thông báo'),
// //             ],
// //             indicatorColor: Colors.red,
// //             labelColor: Colors.white,
// //             unselectedLabelColor: Colors.grey,
// //           ),
// //         ),
// //         body: const TabBarView(
// //           children: [
// //             ArticleListScreen(), // Thay NotificationTab bằng ArticleListScreen
// //             NewsTab(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class NewsTab extends StatelessWidget {
// //   const NewsTab({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return ListView(
// //       padding: const EdgeInsets.all(8.0),
// //       children: [
// //         NotificationItem(
// //           isRead: false,
// //           date: '28/12/23',
// //           title: 'Bản của Giáp Thin đã đến rồi 🎉',
// //         ),
// //       ],
// //     );
// //   }
// // }
//
// //
// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:busmap/widgets/notification_item.dart';
// // import 'article_list_screen.dart';
// //
// // class NotificationScreen extends StatefulWidget {
// //   const NotificationScreen({super.key});
// //
// //   @override
// //   _NotificationScreenState createState() => _NotificationScreenState();
// // }
// //
// // class _NotificationScreenState extends State<NotificationScreen> {
// //   String? userEmail;
// //   int? userId;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadUserData();
// //   }
// //
// //   Future<void> _loadUserData() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       userId = prefs.getInt('user_id');
// //       userEmail = prefs.getString('user_email') ?? 'Không có email';
// //     });
// //
// //     print('user_id trong NotificationScreen: $userId');
// //     print('user_email trong NotificationScreen: $userEmail');
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return DefaultTabController(
// //       length: 2,
// //       child: Scaffold(
// //         appBar: AppBar(
// //           backgroundColor: Colors.green,
// //           elevation: 0,
// //           title: const Text(
// //             'Tin tức và thông báo',
// //             style: TextStyle(color: Colors.white),
// //           ),
// //           bottom: const TabBar(
// //             tabs: [
// //               Tab(text: 'Tin tức'),
// //               Tab(text: 'Thông báo'),
// //             ],
// //             indicatorColor: Colors.red,
// //             labelColor: Colors.white,
// //             unselectedLabelColor: Colors.grey,
// //           ),
// //         ),
// //         body: Column(
// //           children: [
// //             if (userEmail != null)
// //               Container(
// //                 width: double.infinity,
// //                 color: Colors.green.shade100,
// //                 padding: const EdgeInsets.all(12),
// //                 child: Text(
// //                   'Xin chào: $userEmail',
// //                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //                 ),
// //               ),
// //             const Expanded(
// //               child: TabBarView(
// //                 children: [
// //                   ArticleListScreen(), // Tab Tin tức
// //                   NewsTab(),           // Tab Thông báo
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// //   class NewsTab extends StatelessWidget {
// //   const NewsTab({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return ListView(
// //       padding: const EdgeInsets.all(8.0),
// //       children: [
// //         NotificationItem(
// //           isRead: false,
// //           date: '28/12/23',
// //           title: 'Bản của Giáp Thin đã đến rồi 🎉',
// //         ),
// //         NotificationItem(
// //           isRead: true,
// //           date: '21/12/23',
// //           title: 'Xe buýt sẽ thay đổi tuyến vào dịp Tết',
// //         ),
// //       ],
// //     );
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:busmap/widgets/notification_item.dart';
// import 'article_list_screen.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// // Model TripHistory
// class TripHistory {
//   final int id;
//   final String customerName;
//   final String routeNumber;
//   final String startLocation;
//   final String endLocation;
//   final DateTime startTime;
//   final DateTime? endTime;
//   final int? durationMinutes;
//   final int? cost;
//   final DateTime createdAt;
//
//   TripHistory({
//     required this.id,
//     required this.customerName,
//     required this.routeNumber,
//     required this.startLocation,
//     required this.endLocation,
//     required this.startTime,
//     this.endTime,
//     this.durationMinutes,
//     required this.cost,
//     required this.createdAt,
//   });
//
//   factory TripHistory.fromJson(Map<String, dynamic> json) {
//     return TripHistory(
//       id: json['Id'] ?? 0,
//       customerName: json['AccountName'] ?? 'Không rõ',
//       routeNumber: json['RouteNumber'] ?? 'Chưa có',
//       startLocation: json['StartLocation'] ?? 'Chưa có',
//       endLocation: json['EndLocation'] ?? 'Chưa có',
//       startTime: DateTime.parse(json['StartTime'] ?? DateTime.now().toIso8601String()),
//       endTime: json['EndTime'] != null ? DateTime.parse(json['EndTime']) : null,
//       durationMinutes: json['DurationMinutes'] as int?,
//       cost: json['Cost'] as int?,
//       createdAt: DateTime.parse(json['CreatedAt'] ?? DateTime.now().toIso8601String()),
//     );
//   }
// }
//
// // Service TripHistoryService
// class TripHistoryService {
//   final String apiUrl = "https://10.0.2.2:7222"; // Thay bằng URL API thực tế
//
//   Future<List<TripHistory>> fetchTripHistories(int customerId) async {
//     try {
//       final response = await http.get(Uri.parse('$apiUrl/customer/$customerId'));
//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         return data.map((json) => TripHistory.fromJson(json)).toList();
//       } else {
//         throw Exception('Không thể tải lịch sử chuyến đi: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Lỗi khi lấy lịch sử chuyến đi: $e');
//     }
//   }
// }
//
// // NotificationScreen
// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});
//
//   @override
//   _NotificationScreenState createState() => _NotificationScreenState();
// }
//
// class _NotificationScreenState extends State<NotificationScreen> {
//   String? userEmail;
//   int? userId;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }
//
//   Future<void> _loadUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userId = prefs.getInt('user_id');
//       userEmail = prefs.getString('user_email') ?? 'Không có email';
//     });
//
//     print('user_id trong NotificationScreen: $userId');
//     print('user_email trong NotificationScreen: $userEmail');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.green,
//           elevation: 0,
//           title: const Text(
//             'Tin tức và thông báo',
//             style: TextStyle(color: Colors.white),
//           ),
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: 'Tin tức'),
//               Tab(text: 'Thông báo'),
//             ],
//             indicatorColor: Colors.red,
//             labelColor: Colors.white,
//             unselectedLabelColor: Colors.grey,
//           ),
//         ),
//         body: Column(
//           children: [
//             if (userEmail != null)
//               Container(
//                 width: double.infinity,
//                 color: Colors.green.shade100,
//                 padding: const EdgeInsets.all(12),
//                 child: Text(
//                   'Xin chào: $userEmail $userId',
//                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             Expanded(
//               child: TabBarView(
//                 children: [
//                   ArticleListScreen(), // Tab Tin tức
//                   NewsTab(userId: userId), // Tab Thông báo, truyền userId
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // NewsTab
// class NewsTab extends StatefulWidget {
//   final int? userId;
//
//   const NewsTab({super.key, this.userId});
//
//   @override
//   _NewsTabState createState() => _NewsTabState();
// }
//
// class _NewsTabState extends State<NewsTab> {
//   final TripHistoryService _tripService = TripHistoryService();
//   late Future<List<TripHistory>> _tripHistories;
//
//   @override
//   void initState() {
//     super.initState();
//     // Gọi API để lấy lịch sử chuyến đi dựa trên userId
//     _tripHistories = widget.userId != null
//         ? _tripService.fetchTripHistories(widget.userId!)
//         : Future.value([]); // Nếu userId null, trả về danh sách rỗng
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<TripHistory>>(
//       future: _tripHistories,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Lỗi 11: ${snapshot.error}'));
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(child: Text('Không có lịch sử chuyến đi'));
//         }
//
//         final tripHistories = snapshot.data!;
//         return ListView.builder(
//           padding: const EdgeInsets.all(8.0),
//           itemCount: tripHistories.length,
//           itemBuilder: (context, index) {
//             final trip = tripHistories[index];
//             // Định dạng ngày/tháng/năm cho StartTime
//             final startDate = '${trip.startTime.day}/${trip.startTime.month}/${trip.startTime.year}';
//             return Card(
//               margin: const EdgeInsets.symmetric(vertical: 8.0),
//               child: ListTile(
//                 leading: const Icon(Icons.directions_bus, color: Colors.green),
//                 title: Text(
//                   'Chuyến đi: ${trip.startLocation} → ${trip.endLocation}',
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 subtitle: Text('Ngày: $startDate'),
//                 trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                 onTap: () {
//                   // Có thể thêm hành động khi nhấn vào, ví dụ: xem chi tiết chuyến đi
//                 },
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

import 'package:busmap/models/Admin/trip_history.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:busmap/widgets/notification_item.dart';
import 'article_list_screen.dart';
import 'package:busmap/service/Admin/api_trip.dart';

// NotificationScreen
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String? userEmail;
  int? userId;
  String ? fullName;

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
      fullName = prefs.getString('user_name') ?? 'Không có nam';
    });

    print('user_id trong NotificationScreen: $userId');
    print('user_email trong NotificationScreen: $userEmail');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
          title: const Text(
            'Tin tức và thông báo',
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Tin tức'),
              Tab(text: 'Thông báo'),
            ],
            indicatorColor: Colors.red,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: Column(
          children: [
            if (userEmail != null)
              Container(
                width: double.infinity,
                color: Colors.green.shade100,
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Xin chào: $fullName',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            Expanded(
              child: TabBarView(
                children: [
                  ArticleListScreen(),
                  NewsTab(userId: userId),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// NewsTab
class NewsTab extends StatefulWidget {
  final int? userId;

  const NewsTab({super.key, this.userId});

  @override
  _NewsTabState createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  final ApiTripService _tripService = ApiTripService();
  late Future<List<TripHistory>> _tripHistories;

  @override
  void initState() {
    super.initState();
    print('Calling API with userId: ${widget.userId}');
    _tripHistories = widget.userId != null
        ? _tripService.fetchTripHistories(widget.userId!)
        : Future.value([]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TripHistory>>(
      future: _tripHistories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Lỗi: ${snapshot.error}'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _tripHistories = _tripService.fetchTripHistories(widget.userId!);
                    });
                  },
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có lịch sử chuyến đi'));
        }

        final tripHistories = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: tripHistories.length,
          itemBuilder: (context, index) {
            final trip = tripHistories[index];
            final startDate = '${trip.startTime.day}/${trip.startTime.month}/${trip.startTime.year}';
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: const Icon(Icons.directions_bus, color: Colors.green),
                title: Text(
                  'Chuyến đi: ${trip.startLocation} → ${trip.endLocation}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Ngày: $startDate'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            );
          },
        );
      },
    );
  }
}