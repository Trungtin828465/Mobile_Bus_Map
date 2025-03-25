import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:busmap/models/favorite_stop.dart';

class FavoriteStopService {
  final String baseUrl = "https://10.0.2.2:7222/api"; // Thay đổi nếu cần

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
    };
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
      if (response.statusCode == 204) {
        return {};
      }
      return json.decode(response.body);
    } else {
      try {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Lỗi không xác định từ server: ${response.statusCode}');
      } catch (e) {
        throw Exception('Lỗi server: ${response.statusCode} - ${response.body}');
      }
    }
  }

  Future<List<FavoriteStop>> getFavoriteStops(int userId) async {
    try {
      final headers = _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/FavoriteStop?userId=$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => FavoriteStop.fromJson(json)).toList();
      } else {
        try {
          final errorBody = json.decode(response.body);
          throw Exception(errorBody['message'] ?? 'Lỗi không xác định từ server: ${response.statusCode}');
        } catch (e) {
          throw Exception('Lỗi server: ${response.statusCode} - ${response.body}');
        }
      }
    } catch (e) {
      throw Exception("Lỗi khi lấy danh sách trạm dừng yêu thích: $e");
    }
  }

  Future<FavoriteStop> addFavoriteStop(int userId, String stopId, String stopName) async {
    try {
      final headers = _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/FavoriteStop?userId=$userId'),
        headers: headers,
        body: jsonEncode({
          'stopId': stopId,
          'stopName': stopName,
        }),
      );

      final jsonResponse = _handleResponse(response);
      return FavoriteStop.fromJson(jsonResponse);
    } catch (e) {
      throw Exception("Lỗi khi thêm trạm dừng yêu thích: $e");
    }
  }

  Future<bool> deleteFavoriteStop(int userId, String id) async {
    try {
      final headers = _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/FavoriteStop/$id?userId=$userId'),
        headers: headers,
      );

      if (response.statusCode == 204) {
        return true;
      } else {
        try {
          final errorBody = json.decode(response.body);
          throw Exception(errorBody['message'] ?? 'Lỗi không xác định từ server: ${response.statusCode}');
        } catch (e) {
          throw Exception('Lỗi server: ${response.statusCode} - ${response.body}');
        }
      }
    } catch (e) {
      if (e.toString().contains("404")) {
        return false;
      }
      throw Exception("Lỗi khi xóa trạm dừng yêu thích: $e");
    }
  }
}