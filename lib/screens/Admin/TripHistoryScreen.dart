// import 'package:flutter/material.dart';
// import 'package:busmap/models/Admin/trip_history.dart';
// import 'package:busmap/service/Admin/api_trip.dart';
// import 'package:busmap/widgets/Admin/dashboard_appbar.dart';
// import 'package:busmap/widgets/Admin/dashboard_drawer.dart';
//
// class TripHistoryScreen extends StatefulWidget {
//   const TripHistoryScreen({Key? key}) : super(key: key);
//
//   @override
//   _TripHistoryScreenState createState() => _TripHistoryScreenState();
// }
//
// class _TripHistoryScreenState extends State<TripHistoryScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final ApiTripService apiTripService = ApiTripService();
//
//   List<TripHistory> tripHistoryList = []; // Danh sách gốc
//   List<TripHistory> filteredList = []; // Danh sách đã lọc
//   TextEditingController searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     fetchTripHistory();
//   }
//
//   void fetchTripHistory() async {
//     try {
//       List<TripHistory> fetchedTrips = await apiTripService.fetchTrips();
//       setState(() {
//         tripHistoryList = fetchedTrips;
//         filteredList = fetchedTrips; // Mặc định hiển thị toàn bộ
//       });
//     } catch (e) {
//       print("Lỗi: $e");
//     }
//   }
//
//   // Hàm lọc dữ liệu theo tên khách hàng hoặc busNumber
//   void filterTrips(String query) {
//     setState(() {
//       filteredList = tripHistoryList.where((trip) {
//         final customerName = trip.customerName.toLowerCase();
//         final busNumber = trip.routeNumber.toLowerCase();
//         final input = query.toLowerCase();
//         return customerName.contains(input) || busNumber.contains(input);
//       }).toList();
//     });
//   }
//
//   void showTripDetail(TripHistory trip) {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("🚌 Chuyến xe: ${trip.routeNumber}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//               SizedBox(height: 10),
//               Text("Tên: ${trip.customerName}", style: TextStyle(fontSize: 18)),
//               Text("📍 Điểm đi: ${trip.startLocation}", style: TextStyle(fontSize: 18)),
//               Text("📍 Điểm đến: ${trip.endLocation}", style: TextStyle(fontSize: 18)),
//               Text("⏱ Bắt đầu: ${trip.startTime}", style: TextStyle(fontSize: 18)),
//               Text("⌛ Thời gian: ${trip.durationMinutes ?? 'Chưa có'} phút", style: TextStyle(fontSize: 18)),
//               Text("💰 Giá vé: ${trip.cost} VND", style: TextStyle(fontSize: 18)),
//               SizedBox(height: 20),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text("Đóng"),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: DashboardAppBar(scaffoldKey: _scaffoldKey),
//       drawer: const DashboardDrawer(),
//       body: Column(
//         children: [
//           // Ô nhập tìm kiếm
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               controller: searchController,
//               decoration: InputDecoration(
//                 labelText: "Tìm kiếm theo tên khách hàng hoặc số xe",
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//               ),
//               onChanged: filterTrips,
//             ),
//           ),
//           Expanded(
//             child: filteredList.isEmpty
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//               itemCount: filteredList.length,
//               itemBuilder: (context, index) {
//                 final trip = filteredList[index];
//                 return Card(
//                   margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   child: ListTile(
//                     leading: CircleAvatar(child: Text("${index + 1}")), // Số thứ tự
//                     title: Text("${trip.startLocation} ➝ ${trip.endLocation}"),
//                     subtitle: Text("Tên: ${trip.customerName}\nBắt đầu: ${trip.startTime}"),
//                     onTap: () {
//                       showTripDetail(trip);
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:busmap/models/Admin/trip_history.dart';
import 'package:busmap/service/Admin/api_trip.dart';
import 'package:busmap/widgets/Admin/dashboard_appbar.dart';
import 'package:busmap/widgets/Admin/dashboard_drawer.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({Key? key}) : super(key: key);

  @override
  _TripHistoryScreenState createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiTripService apiTripService = ApiTripService();

  List<TripHistory> tripHistoryList = [];
  List<TripHistory> filteredList = [];
  TextEditingController searchController = TextEditingController();
  late Future<List<TripHistory>> _tripHistoryFuture;

  @override
  void initState() {
    super.initState();
    _tripHistoryFuture = fetchTripHistory();
  }

  Future<List<TripHistory>> fetchTripHistory() async {
    try {
      final trips = await apiTripService.fetchTrips();
      setState(() {
        tripHistoryList = trips;
        filteredList = trips; // Ban đầu hiển thị toàn bộ danh sách
      });
      return trips;
    } catch (e) {
      throw Exception('Lỗi khi tải lịch sử chuyến đi: $e');
    }
  }

  // Hàm lọc dữ liệu theo tên khách hàng hoặc số xe
  void filterTrips(String query) {
    setState(() {
      filteredList = tripHistoryList.where((trip) {
        final customerName = trip.fullName.toLowerCase();
        final busNumber = trip.routeNumber.toLowerCase();
        final input = query.toLowerCase();
        return customerName.contains(input) || busNumber.contains(input);
      }).toList();
    });
  }

  void showTripDetail(TripHistory trip) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.directions_bus, color: Colors.green, size: 30),
                  const SizedBox(width: 10),
                  Text(
                    "Chuyến xe: ${trip.routeNumber}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.grey, height: 20, thickness: 0.5),
              const SizedBox(height: 10),
              _buildDetailRow(Icons.person, "Tên: ${trip.fullName}"),
              _buildDetailRow(Icons.location_on, "Điểm đi: ${trip.startLocation}"),
              _buildDetailRow(Icons.location_on_outlined, "Điểm đến: ${trip.endLocation}"),
              _buildDetailRow(
                Icons.calendar_today,
                "Bắt đầu: ${trip.startTime.day}/${trip.startTime.month}/${trip.startTime.year}",
              ),
              _buildDetailRow(
                Icons.timer,
                "Thời gian: ${trip.durationMinutes ?? 'Chưa có'} phút",
              ),
              _buildDetailRow(
                Icons.attach_money,
                "Giá vé: ${trip.cost != null ? '${trip.cost} VND' : 'Chưa có'}",
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Đóng",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Hàm hỗ trợ để hiển thị các hàng chi tiết trong BottomSheet
  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: DashboardAppBar(scaffoldKey: _scaffoldKey),
      ),
      drawer: const DashboardDrawer(),
      body: Column(
        children: [
          // Ô nhập tìm kiếm
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Tìm kiếm theo tên khách hàng hoặc số xe",
                labelStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.green),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: filterTrips,
            ),
          ),
          // Danh sách lịch sử chuyến đi
          Expanded(
            child: FutureBuilder<List<TripHistory>>(
              future: _tripHistoryFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.green),
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
                            setState(() {
                              _tripHistoryFuture = fetchTripHistory();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Thử lại',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'Không có lịch sử chuyến đi',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                tripHistoryList = snapshot.data!;
                filteredList = tripHistoryList;

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final trip = filteredList[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          child: Text("${index + 1}"),
                        ),
                        title: Text(
                          "${trip.startLocation} ➝ ${trip.endLocation}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              "Tên: ${trip.fullName}",
                              style: const TextStyle(fontSize: 14, color: Colors.black54),
                            ),
                            Text(
                              "Bắt đầu: ${trip.startTime.day}/${trip.startTime.month}/${trip.startTime.year}",
                              style: const TextStyle(fontSize: 14, color: Colors.black54),
                            ),
                          ],
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.green,
                          size: 16,
                        ),
                        onTap: () {
                          showTripDetail(trip);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}