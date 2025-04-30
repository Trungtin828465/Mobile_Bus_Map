// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'dart:io';
// import 'package:busmap/models/Admin/trip_history.dart';
//
// class ApiTripService {
//   final String apiUrl = "https://10.0.2.2:7222/api/triphistory"; // API URL
//
//
//   Future<List<TripHistory>> fetchTrips() async {
//     try {
//       HttpClient client = HttpClient();
//       client.badCertificateCallback = (cert, host, port) => true;
//
//       HttpClientRequest request = await client.getUrl(Uri.parse(apiUrl));
//       HttpClientResponse response = await request.close();
//       String jsonResponse = await response.transform(utf8.decoder).join();
//
//       print("🔹 API Response: $jsonResponse"); // In response để debug
//
//       if (response.statusCode == 200) {
//         var decodedJson = json.decode(jsonResponse);
//
//         // Nếu API trả về một Map có key "$values"
//         if (decodedJson is Map<String, dynamic> && decodedJson.containsKey("\$values")) {
//           return (decodedJson["\$values"] as List)
//               .map((json) => TripHistory.fromJson(json))
//               .toList();
//         }
//
//         // Nếu API trả về một List trực tiếp
//         if (decodedJson is List) {
//           return decodedJson.map((json) => TripHistory.fromJson(json)).toList();
//         }
//
//         throw Exception("Dữ liệu API không đúng định dạng mong đợi.");
//       } else {
//         throw Exception("Lỗi API: ${response.statusCode} - $jsonResponse");
//       }
//     } catch (e) {
//       throw Exception("Lỗi kết nối API: $e");
//     }
//   }
//   /// Lấy danh sách lịch sử chuyến đi theo customerId
//   Future<List<TripHistory>> fetchTripHistories(int customerId) async {
//     try {
//       // Gọi API với customerId
//       final response = await http.get(Uri.parse('$apiUrl/customer/$customerId'));
//
//       // Kiểm tra trạng thái phản hồi
//       if (response.statusCode == 200) {
//         // Chuyển JSON thành danh sách TripHistory
//         List<dynamic> data = json.decode(response.body);
//         return data.map((json) => TripHistory.fromJson(json)).toList();
//       } else {
//         // Ném ngoại lệ nếu không thành công
//         throw Exception('Không thể tải lịch sử chuyến đi: ${response.statusCode}');
//       }
//     } catch (e) {
//       // Xử lý lỗi (mất kết nối, JSON không hợp lệ, v.v.)
//       throw Exception('Lỗi khi lấy lịch sử chuyến đi: $e');
//     }
//   }
//
// }


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:busmap/models/Admin/trip_history.dart';

class ApiTripService {
  final String apiUrl = "https://10.0.2.2:7222/api/triphistory"; // API URL

  Future<List<TripHistory>> fetchTrips() async {
    try {
      HttpClient client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;

      HttpClientRequest request = await client.getUrl(Uri.parse(apiUrl));
      HttpClientResponse response = await request.close();
      String jsonResponse = await response.transform(utf8.decoder).join();

      print("🔹 API Response: $jsonResponse"); // In response để debug

      if (response.statusCode == 200) {
        var decodedJson = json.decode(jsonResponse);

        // Nếu API trả về một Map có key "$values"
        if (decodedJson is Map<String, dynamic> && decodedJson.containsKey("\$values")) {
          return (decodedJson["\$values"] as List)
              .map((json) => TripHistory.fromJson(json))
              .toList();
        }

        // Nếu API trả về một List trực tiếp
        if (decodedJson is List) {
          return decodedJson.map((json) => TripHistory.fromJson(json)).toList();
        }

        throw Exception("Dữ liệu API không đúng định dạng mong đợi.");
      } else {
        throw Exception("Lỗi API: ${response.statusCode} - $jsonResponse");
      }
    } catch (e) {
      throw Exception("Lỗi kết nối API: $e");
    }
  }

  /// Lấy danh sách lịch sử chuyến đi theo customerId
  Future<List<TripHistory>> fetchTripHistories(int customerId) async {
    try {
      // Gọi API với customerId
      final response = await http.get(
        Uri.parse('$apiUrl/customer/$customerId'),
        headers: {
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var decodedJson = json.decode(response.body);

        // Nếu API trả về một Map có key "$values"
        if (decodedJson is Map<String, dynamic> && decodedJson.containsKey("\$values")) {
          return (decodedJson["\$values"] as List)
              .map((json) => TripHistory.fromJson(json))
              .toList();
        }

        // Nếu API trả về một List trực tiếp
        if (decodedJson is List) {
          return decodedJson.map((json) => TripHistory.fromJson(json)).toList();
        }

        throw Exception("Dữ liệu API không đúng định dạng mong đợi.");
      } else {
        throw Exception('Không thể tải lịch sử chuyến đi: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi khi lấy lịch sử chuyến đi: $e');
    }
  }
}