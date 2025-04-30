import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:busmap/models/Khanh/article.dart';

class ArticleService {
  static const String baseUrl = 'https://10.0.2.2:7222/api/articles'; // Thay bằng URL API thực tế của bạn


  Future<List<Article>> getArticles() async {
    try {
      HttpClient client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true; // Bỏ qua SSL

      HttpClientRequest request = await client.getUrl(Uri.parse(baseUrl));
      HttpClientResponse response = await request.close();
      if (response.statusCode == 200) {
        String jsonResponse = await response.transform(utf8.decoder).join();
        print("🔹 API Response: $jsonResponse"); // Log để kiểm tra dữ liệu

        // Giải mã JSON
        var decodedJson = json.decode(jsonResponse);

        // Xử lý dữ liệu là danh sách trực tiếp
        if (decodedJson is List) {
          return decodedJson.map((json) => Article.fromJson(json)).toList();
        } else {
          throw Exception("Dữ liệu API không đúng định dạng mong đợi: không phải danh sách.");
        }
      } else {
        throw Exception("Lỗi khi tải danh sách bài viết: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception("Lỗi kết nối API: Không thể kết nối tới server - $e");
      } else if (e is FormatException) {
        throw Exception("Lỗi phân tích JSON: Dữ liệu không đúng định dạng - $e");
      } else {
        throw Exception("Lỗi không xác định khi gọi API: $e");
      }
    }
  }


  Future<Article> getArticleById(int id) async {
    try {
      final url = '$baseUrl/$id';
      print('Requesting URL: $url'); // In URL để kiểm tra
      final response = await http.get(Uri.parse(url));
      print('Response status: ${response.statusCode}'); // In mã trạng thái
      print('Response body: ${response.body}'); // In nội dung phản hồi

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Article.fromJson(data);
      } else {
        throw Exception('Failed to load article: Status ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error loading article: $e');
    }
  }
}