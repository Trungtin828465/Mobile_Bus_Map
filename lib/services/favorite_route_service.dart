import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:busmap/models/BusRoute/favorite_route.dart';

class FavoriteRouteService {
  final String baseUrl;

  FavoriteRouteService() : baseUrl = _determineBaseUrl();

  static String _determineBaseUrl() {
    const androidEmulatorBaseUrl = "https://10.0.2.2:7222/api"; // Đổi từ http sang https
    const iosSimulatorBaseUrl = "https://localhost:7222/api";
    const physicalDeviceBaseUrl = "https://192.168.1.x:7222/api"; // Thay 192.168.1.x bằng IP thực tế
    return androidEmulatorBaseUrl;
  }

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

  Future<List<FavoriteRoute>> getFavoriteRoutes(int userId) async {
    // Kiểm tra đầu vào
    if (userId <= 0) {
      throw Exception("userId phải lớn hơn 0.");
    }

    try {
      final headers = _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/FavoriteRoute?userId=$userId'),
        headers: headers,
      );

      final jsonResponse = _handleResponse(response);
      if (jsonResponse is List) {
        return jsonResponse.map((json) => FavoriteRoute.fromJson(json)).toList();
      } else {
        throw Exception('Dữ liệu trả về không phải là danh sách tuyến yêu thích');
      }
    } catch (e) {
      if (e.toString().contains("Connection closed")) {
        throw Exception("Không thể kết nối đến server. Vui lòng kiểm tra server hoặc kết nối mạng.");
      }
      throw Exception('Không thể lấy danh sách tuyến yêu thích: $e');
    }
  }

  Future<FavoriteRoute> addFavoriteRoute(int userId, String routeNo, String routeName) async {
    // Kiểm tra đầu vào
    if (userId <= 0) {
      throw Exception("userId phải lớn hơn 0.");
    }
    if (routeNo.trim().isEmpty) {
      throw Exception("Mã tuyến không được để trống.");
    }
    if (routeName.trim().isEmpty) {
      throw Exception("Tên tuyến không được để trống.");
    }

    try {
      final headers = _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/FavoriteRoute?userId=$userId'),
        headers: headers,
        body: jsonEncode({
          'routeNo': routeNo.trim(),
          'routeName': routeName.trim(),
        }),
      );

      final jsonResponse = _handleResponse(response);
      return FavoriteRoute.fromJson(jsonResponse);
    } catch (e) {
      if (e.toString().contains("400")) {
        throw Exception("Yêu cầu không hợp lệ: $e");
      }
      throw Exception('Không thể thêm tuyến yêu thích: $e');
    }
  }

  Future<bool> deleteFavoriteRoute(int userId, String id) async {
    // Kiểm tra đầu vào
    if (userId <= 0) {
      throw Exception("userId phải lớn hơn 0.");
    }
    if (id.trim().isEmpty) {
      throw Exception("ID tuyến không được để trống.");
    }

    try {
      final headers = _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/FavoriteRoute/$id?userId=$userId'),
        headers: headers,
      );

      _handleResponse(response);
      return true;
    } catch (e) {
      if (e.toString().contains("404")) {
        return false;
      }
      throw Exception('Không thể xóa tuyến yêu thích: $e');
    }
  }
}