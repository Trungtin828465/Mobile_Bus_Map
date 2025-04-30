//
// import 'dart:convert';
// class TripHistory {
//   final int id;
//   final int customerId;
//   final String customerName; // Thêm tên khách hàng
//   final String routeNumber;
//   final String startLocation;
//   final String endLocation;
//   final DateTime startTime;
//   final DateTime? endTime;
//   final int? durationMinutes;
//   final int? cost;
//
//   final DateTime createdAt;
//
//   TripHistory({
//     required this.id,
//     required this.customerId,
//     required this.customerName, // Nhận tên khách hàng
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
//       id: json['Id'] ?? 0, // Nếu null, gán 0
//       customerId: json['CustomerId'] ?? 0, // Nếu null, gán 0
//       customerName: json['AccountName'] ?? 'Không rõ', // Nếu null, gán mặc định
//       routeNumber: json['RouteNumber'] ?? 'Chưa có',
//       startLocation: json['StartLocation'] ?? 'Chưa có',
//       endLocation: json['EndLocation'] ?? 'Chưa có',
//       startTime: DateTime.parse(json['StartTime'] ?? DateTime.now().toIso8601String()),
//       endTime: json['EndTime'] != null ? DateTime.parse(json['EndTime']) : null,
//       durationMinutes: json['DurationMinutes'] as int?, // Có thể null
//       cost: json['Cost'] as int?, // Nếu null, gán 0
//       createdAt: DateTime.parse(json['CreatedAt'] ?? DateTime.now().toIso8601String()),
//     );
//   }
//
//
//   static List<TripHistory> fromJsonList(String jsonStr) {
//     final List<dynamic> data = json.decode(jsonStr);
//     return data.map((json) => TripHistory.fromJson(json)).toList();
//   }
// }
import 'dart:convert';

class TripHistory {
  final int id;
  final int customerId;
  final String fullName;
  final String routeNumber;
  final String startLocation;
  final String endLocation;
  final DateTime startTime;
  final DateTime? endTime;
  final int? durationMinutes;
  final int? cost;
  final DateTime createdAt;
  final double? walkingDistance; // Thêm trường WalkingDistance
  final double? busDistance; // Thêm trường BusDistance

  TripHistory({
    required this.id,
    required this.customerId,
    required this.fullName,
    required this.routeNumber,
    required this.startLocation,
    required this.endLocation,
    required this.startTime,
    this.endTime,
    this.durationMinutes,
    this.cost,
    required this.createdAt,
    this.walkingDistance,
    this.busDistance,
  });

  factory TripHistory.fromJson(Map<String, dynamic> json) {
    return TripHistory(
      id: json['Id'] ?? 0,
      customerId: json['CustomerId'] ?? 0,
      fullName: json['FullName'] ?? 'Không rõ',

      routeNumber: json['RouteNumber'] ?? 'Chưa có',
      startLocation: json['StartLocation'] ?? 'Chưa có',
      endLocation: json['EndLocation'] ?? 'Chưa có',
      startTime: DateTime.parse(json['StartTime'] ?? DateTime.now().toIso8601String()),
      endTime: json['EndTime'] != null ? DateTime.parse(json['EndTime']) : null,
      durationMinutes: json['DurationMinutes'] as int?,
      cost: json['Cost'] as int?,
      createdAt: DateTime.parse(json['CreatedAt'] ?? DateTime.now().toIso8601String()),
      walkingDistance: (json['WalkingDistance'] as num?)?.toDouble(),
      busDistance: (json['BusDistance'] as num?)?.toDouble(),
    );
  }

  static List<TripHistory> fromJsonList(String jsonStr) {
    final List<dynamic> data = json.decode(jsonStr);
    return data.map((json) => TripHistory.fromJson(json)).toList();
  }
}