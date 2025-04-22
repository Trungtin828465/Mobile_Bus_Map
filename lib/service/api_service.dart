import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:busmap/models/BusStopModel/BusStopModel.dart';


class ApiService {
  final String baseUrl =
      "https://10.0.2.2:7222/api/busstops"; // Đổi cổng đúng với API
  Future<List<BusStopModel>> fetchBusStops() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/TinBusStop'));

      print("📡 Đang gọi API: $baseUrl/TinBusStop");
      print("🔄 Status Code API: ${response.statusCode}");
      print("📦 Response Body API: ${response.body}");

      if (response.statusCode == 200) {
        // Giải mã phản hồi dưới dạng List<dynamic>
        final List<dynamic> decoded = json.decode(response.body);

        // Ánh xạ danh sách thành các đối tượng BusStopModel
        List<BusStopModel> busStops =
        decoded.map((json) => BusStopModel.fromJson(json)).toList();
        print("✅ Số lượng điểm dừng nhận được: ${busStops.length}");
        return busStops;
      } else {
        print("⚠️ API trả về lỗi: ${response.body}");
        throw Exception("Lỗi từ API: ${response.body}");
      }
    } catch (e) {
      print("❌ Lỗi không xác định bus stop: $e");
      throw Exception("Lỗi tải điểm dừng: $e");
    }
  }


  // Xử lý phản hồi chung
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
        json.decode(response.body)['message'] ?? 'Lỗi không xác định',
      );
    }
  }
}
