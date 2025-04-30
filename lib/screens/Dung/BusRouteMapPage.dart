import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:busmap/Router.dart';
// Class to display a bus route map with two tabs: Route Details and Bus Stops
class BusRouteMapPage extends StatefulWidget {
  final Map<String, dynamic> routeData; // API response
  final String fromLocation;
  final String toLocation;

  const BusRouteMapPage({Key? key, required this.routeData, required this.fromLocation,
    required this.toLocation,}) : super(key: key);

  @override
  _BusRouteMapPageState createState() => _BusRouteMapPageState();
}

class _BusRouteMapPageState extends State<BusRouteMapPage> with SingleTickerProviderStateMixin {
  String tileUrl = "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png";
  List<LatLng> routePoints = [];
  List<dynamic> stops = [];
  List<dynamic> routeDetails = [];
  String routeTitle = "";
  String routeDesc = "";
  double totalWalkingDistance = 0.0;
  double totalBusDistance = 0.0;
  int totalFare = 0;
  bool isLoading = true;
  late TabController _tabController;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    processRouteData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  Future<void> saveTrip(Trip trip) async {
    // Replace '8080' with the actual port your backend server is running on
    final url = Uri.parse('https://10.0.2.2:7222/api/TripHistory'); // For Android emulator
    // If testing on a real device, use your computer's IP, e.g., 'http://192.168.1.x:8080/api/TripHistory'

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(trip.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Lưu lịch sử chuyến đi thành công!');
      } else {
        print('Lỗi: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to save Trip: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving Trip: $e');
      throw Exception('Error saving Trip: $e');
    }
  }

  void processRouteData() {
    try {
      setState(() {
        routeTitle = widget.routeData["Title"] ?? "Unknown Route";
        routeDesc = widget.routeData["Desc"] ?? "";
        stops = widget.routeData["stops"] ?? [];
        routeDetails = widget.routeData["detail"] ?? [];

        // Extract route coordinates from coordRoute
        Map<String, dynamic> coordRoute = widget.routeData["coordRoute"] ?? {};
        List<List<LatLng>> allRoutePoints = [];

        if (coordRoute.isNotEmpty) {
          coordRoute.forEach((key, coordinates) {
            List<LatLng> segment = [];
            for (var coord in coordinates) {
              if (coord.containsKey("Latitude") && coord.containsKey("Longitude")) {
                double? lat = double.tryParse(coord["Latitude"].toString());
                double? lng = double.tryParse(coord["Longitude"].toString());
                if (lat != null && lng != null) {
                  segment.add(LatLng(lat, lng));
                }
              }
            }
            if (segment.isNotEmpty) {
              allRoutePoints.add(segment);
            }
          });
        }

        // Flatten allRoutePoints into a single list of LatLng points
        routePoints = allRoutePoints.expand((e) => e).toList();

        totalWalkingDistance = 0.0;
        totalBusDistance = 0.0;
        totalFare = 0;

        for (var detail in routeDetails) {
          double distance = double.tryParse(detail["Distance"].toString()) ?? 0.0;
          if (detail["RouteNo"] == null) {
            totalWalkingDistance += distance;
          } else {
            totalBusDistance += distance;
            totalFare += int.tryParse(detail["Fare"].toString()) ?? 0;
          }
        }

        totalWalkingDistance = totalWalkingDistance / 1000;
        totalBusDistance = totalBusDistance / 1000;

        isLoading = false;
      });
    } catch (e) {
      print("Error processing route data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Bus Route Map"),
      //   backgroundColor: Colors.blue,
      // ),
      body: Stack(
        children: [
          // Map
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (stops.isEmpty)
            const Center(child: Text("Không có dữ liệu trạm xe buýt!"))
          else
            FlutterMap(
              mapController: _mapController, // thêm dòng này
              options: MapOptions(
                initialCenter: LatLng(stops[0]["Lat"], stops[0]["Lng"]),
                initialZoom: 15,
              ),
              children: [
                TileLayer(urlTemplate: tileUrl),
                if (routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routePoints,
                        color: Colors.blue,
                        strokeWidth: 4.0,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: stops.map((stop) {
                    return Marker(
                      point: LatLng(stop["Lat"], stop["Lng"]),
                      width: 30,
                      height: 35.0,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,  // Outer circle color
                        child: CircleAvatar(
                          radius: 18,  // Inner circle size
                          backgroundColor: stop["Type"] == 0
                              ? Colors.red
                              : stop["Type"] == -2
                              ? Colors.blue
                              : Colors.green,  // Color based on stop type
                          child: Icon(
                            Icons.directions_bus,
                            color: Colors.white,
                            size: 20,  // Icon size inside the circle
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

              ],
            ),
          // Nút Back
          Positioned(
            top: 30,
            left: 10,
            child: FloatingActionButton(
              onPressed: () {
                  FluroRouterConfig.navigateToPage(context, "/findway", slideFromRight: false);
              },
              backgroundColor: Colors.white,
              elevation: 3,
              shape: const CircleBorder(),
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
          //nut bat dau
          Positioned(
            top: 30,
            left: 340,
            child: FloatingActionButton(
              onPressed: () async {
                if (stops.isNotEmpty) {
                  final startPoint = LatLng(stops[0]["Lat"], stops[0]["Lng"]);
                  _mapController.move(startPoint, 15);

                  // Debug: Print all routeDetails entries
                  print('routeDetails: $routeDetails');
                  for (var i = 0; i < routeDetails.length; i++) {
                    print('routeDetails[$i]: ${routeDetails[i]}');
                    print('routeDetails[$i]["RouteNo"]: ${routeDetails[i]["RouteNo"]}');
                  }

                  // Function to get the first valid RouteNo
                  String getRouteNumber() {
                    for (var detail in routeDetails) {
                      if (detail["RouteNo"] != null) {
                        return detail["RouteNo"].toString();
                      }
                    }
                    return "No Route Available";
                  }

                  // Validate before saving
                  String routeNumber = routeDetails.isNotEmpty ? getRouteNumber() : "No Route Available";
                  if (routeNumber == "No Route Available") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Cannot save trip: No valid route number found')),
                    );
                    return;
                  }

                  // Create a Trip object
                  final trip = Trip(
                    customerId: 1, // Replace with actual customerId
                    startLocation: widget.fromLocation,
                    endLocation: widget.toLocation,
                    startTime: DateTime.now(),
                    endTime: DateTime.now().add(Duration(minutes: (totalBusDistance * 60).toInt())),
                    routeNumber: routeNumber,
                    cost: totalFare,
                    durationMinutes: (totalBusDistance * 60).toInt(),
                    walkingDistance: (totalWalkingDistance * 1000).toInt(),
                    busDistance: totalBusDistance,
                  );

                  // Save the trip
                  try {
                    await saveTrip(trip);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Trip saved successfully!')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error saving trip: $e')),
                    );
                  }
                }
              },
              backgroundColor: Colors.white,
              elevation: 3,
              shape: const CircleBorder(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.fmd_good_sharp, color: Colors.red, size: 22),
                  SizedBox(height: 2),
                  Text(
                    "Start",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Draggable bottom sheet for resizing
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.24,
            maxChildSize: 0.76,
            builder: (BuildContext context, ScrollController scrollController) {
              bool isDragging = false; // Biến kiểm soát khi kéo
              return Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 10),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Drag handle
                        Container(
                          width: 40,
                          height: 5,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        // Route title and summary with adjusted sizes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.directions_bus,
                                  color: Colors.red,
                                  size: 28, // Adjusted icon size
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  routeTitle,
                                  style: const TextStyle(
                                    fontSize: 21, // Adjusted font size
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.monetization_on_outlined,
                              size: 24, // Adjusted icon size
                              color: Colors.green,
                            ),
                            Text(
                              "$totalFare VND - ${(totalBusDistance * 60).toInt()} phút",
                              style: const TextStyle(
                                fontSize: 19, // Adjusted font size
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.directions_walk,
                              size: 25, // Adjusted icon size
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${(totalWalkingDistance * 1000).toInt()} m",
                              style: const TextStyle(fontSize: 19), // Adjusted font size
                            ),
                            const SizedBox(width: 16),
                            const Icon(
                              Icons.directions,
                              size: 25, // Adjusted icon size
                              color: Colors.deepOrange,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${totalBusDistance.toStringAsFixed(1)} km",
                              style: const TextStyle(fontSize: 19), // Adjusted font size
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // TabBar with adjusted sizes
                        TabBar(
                          controller: _tabController,
                          labelColor: Colors.blue,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Colors.blue,
                          labelStyle: const TextStyle(
                            fontSize: 18, // Adjusted font size for selected tab
                            fontWeight: FontWeight.bold,
                          ),
                          unselectedLabelStyle: const TextStyle(
                            fontSize: 16, // Adjusted font size for unselected tab
                          ),
                          labelPadding: const EdgeInsets.symmetric(vertical: 10),
                          tabs: const [
                            Tab(icon: Icon(Icons.directions, color: Colors.deepOrange), text: "CHI TIẾT CÁCH ĐI"),
                            Tab(icon: Icon(Icons.directions_bus, color: Colors.green), text: "CÁC TRẠM ĐI QUA"),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Tab content with adjusted sizes
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45, // Increased height for tab content
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              // Route details
                              SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (routeDesc.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        // child: Text(
                                        //   routeDesc,
                                        //   style: const TextStyle(
                                        //     fontSize: 17, // Adjusted font size
                                        //     color: Colors.black54,
                                        //   ),
                                        // ),
                                      ),
                                    ...routeDetails.asMap().entries.map((entry) {
                                      var detail = entry.value;
                                      bool isWalking = detail["RouteNo"] == null;
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              isWalking
                                                  ? Icons.directions_walk
                                                  : Icons.directions_bus,
                                              color: isWalking
                                                  ? Colors.blue
                                                  : entry.key == 0
                                                  ? Colors.green
                                                  : Colors.red,
                                              size: 25, // Adjusted icon size
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    isWalking
                                                        ? entry.key == 0
                                                        ? "Đi bộ từ điểm xuất phát đến trạm đầu tiên: ${detail["Distance"]} m"
                                                        : entry.key == detail.length - 1
                                                        ? "Đi bộ đến điểm đến: ${detail["Distance"]} m"
                                                        : "Đi bộ từ trạm cuối cùng đến điểm đến: ${detail["Distance"]} m"
                                                        : "${detail["RouteNo"]}: ${detail["GetIn"]} → ${detail["GetOff"]} (${detail["Distance"]} m, ${NumberFormat("#,##0", "vi_VN").format(detail["Fare"])} VNĐ)",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: isWalking ? FontWeight.normal : FontWeight.bold,
                                                      color: isWalking ? Colors.black : Colors.black87,
                                                    ),
                                                    softWrap: true,
                                                  ),

                                                  const SizedBox(height: 6), // Khoảng cách giữa text và dòng kẻ
                                                  const Divider(
                                                    color: Colors.grey,
                                                    thickness: 1,
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            ),

                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                              // Bus stops
                              // Bus stops
                              SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Danh sách các trạm dừng:",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ...stops.map((stop) {
                                      // Chọn màu dựa trên Type
                                      print("Stop Name: ${stop["Name"]}, Type: ${stop["Type"]}");

                                      Color iconColor;
                                      switch (stop["Type"]) {
                                        case 0:
                                          iconColor = Colors.red; // Xuất phát
                                          break;
                                        case -2:
                                          iconColor = Colors.blue; // Đích
                                          break;
                                        default:
                                          iconColor = Colors.green; // Trạm thường
                                      }

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.directions_bus,
                                                  color: iconColor,
                                                  size: 25,
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    stop["Name"] ?? "",
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Divider(), // Dòng kẻ phân cách dưới mỗi trạm
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ],

                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}



class Trip {
  final int customerId;
  final String startLocation;
  final String endLocation;
  final DateTime startTime;
  final DateTime? endTime;
  final String routeNumber;
  final int? cost;
  final int? durationMinutes;
  final int? walkingDistance;
  final double? busDistance;

  Trip({
    required this.customerId,
    required this.startLocation,
    required this.endLocation,
    required this.startTime,
    this.endTime,
    required this.routeNumber,
    this.cost,
    this.durationMinutes,
    this.walkingDistance,
    this.busDistance,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'startLocation': startLocation,
      'endLocation': endLocation,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'routeNumber': routeNumber,
      'cost': cost,
      'durationMinutes': durationMinutes,
      'walkingDistance': walkingDistance,
      'busDistance': busDistance,
    };
  }
}