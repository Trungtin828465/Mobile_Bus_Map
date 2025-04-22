import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:busmap/models/Admin/accounts.dart';
import 'package:busmap/models/Admin/Register.dart';
import 'package:busmap/models/Admin/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ApiService {
  final String apiUrl = "https://10.0.2.2:7222/api/accounts";

  Future<List<CustomerAccount>> fetchAccounts() async {
    try {
      HttpClient client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true; // Bỏ qua SSL

      HttpClientRequest request = await client.getUrl(Uri.parse(apiUrl));
      HttpClientResponse response = await request.close();
      String jsonResponse = await response.transform(utf8.decoder).join();

      print("🔹 API Response: $jsonResponse"); // In ra để kiểm tra JSON
      print("🔹 Status Code: ${response.statusCode}"); // Kiểm tra status code

      if (response.statusCode == 200) {
        var decodedJson = json.decode(jsonResponse);

        // Nếu API trả về Map, kiểm tra có "$values" không
        if (decodedJson is Map<String, dynamic> && decodedJson.containsKey("\$values")) {
          return (decodedJson["\$values"] as List)
              .map((json) => CustomerAccount.fromJson(json))
              .toList();
        }

        // Nếu API trả về List, dùng trực tiếp
        if (decodedJson is List) {
          return decodedJson.map((json) => CustomerAccount.fromJson(json)).toList();
        }

        throw Exception("Dữ liệu API /accounts không đúng định dạng mong đợi.");
      } else {
        throw Exception("Lỗi API /accounts: ${response.statusCode} - $jsonResponse");
      }
    } catch (e) {
      throw Exception("Lỗi kết nối API /accounts: $e");
    }
  }



// XG
  // Xử lý phản hồi chung
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(json.decode(response.body)['message'] ?? 'Lỗi không xác định');
    }
  }

}
