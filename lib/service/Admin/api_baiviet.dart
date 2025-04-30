import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:busmap/models/Admin/BaiViet.dart';

class ApiService {
  static const String baseUrl = 'https://10.0.2.2:7222/api/articles';

  // Future<List<Article>> fetchArticles() async {
  //   try {
  //     // Sử dụng package http thay vì HttpClient
  //     HttpClient client = HttpClient();
  //     client.badCertificateCallback = (cert, host, port) => true; // Bỏ qua SSL
  //
  //     HttpClientRequest request = await client.getUrl(Uri.parse(baseUrl));
  //     HttpClientResponse response = await request.close();
  //     if (response.statusCode == 200) {
  //       // Giải mã JSON từ response body
  //       String jsonResponse = await response.transform(utf8.decoder).join();
  //       Map<String, dynamic> decodedJson = json.decode(jsonResponse);
  //       // Kiểm tra cấu trúc JSON có chứa "$values"
  //       if (decodedJson.containsKey("\$values")) {
  //         List<dynamic> data = decodedJson["\$values"];
  //         return data.map((json) => Article.fromJson(json)).toList();
  //       } else {
  //         throw Exception(
  //             "Dữ liệu API không chứa trường '\$values' như mong đợi.");
  //       }
  //     } else {
  //       throw Exception(
  //           "Lỗi khi tải danh sách bài viết: ${response.statusCode} - ${response
  //               .reasonPhrase}");
  //     }
  //   } catch (e) {
  //     // Xử lý lỗi cụ thể hơn
  //     if (e is http.ClientException) {
  //       throw Exception("Lỗi kết nối API: Không thể kết nối tới server - $e");
  //     } else if (e is FormatException) {
  //       throw Exception(
  //           "Lỗi phân tích JSON: Dữ liệu không đúng định dạng - $e");
  //     } else {
  //       throw Exception("Lỗi không xác định khi gọi API: $e");
  //     }
  //   }
  // }
  Future<List<Article>> fetchArticles() async {
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


  Future<bool> createArticle(Article article) async {
    try {
      HttpClient client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true; // Bỏ qua SSL

      HttpClientRequest request = await client.postUrl(Uri.parse(baseUrl));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");

      String jsonBody = json.encode(article.toJson());
      print("🔹 JSON gửi lên API: $jsonBody");

      request.add(utf8.encode(jsonBody));

      HttpClientResponse response = await request.close();
      String responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 201) {
        return true;
      } else {
        print("❌ Lỗi API: $responseBody");
        return false;
      }
    } catch (e) {
      print("🚨 Lỗi kết nối API: $e");
      return false;
    }
  }

  Future<bool> updateArticle(Article article) async {
    try {
      final url = Uri.parse('$baseUrl/${article.id}'); // URL API

      HttpClient client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;

      HttpClientRequest request = await client.putUrl(url);
      request.headers.set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");

      // Thêm iD_BaiViet vào body
      Map<String, dynamic> jsonData = article.toJson();
      jsonData["iD_BaiViet"] = article.id;
      String jsonBody = jsonEncode(jsonData);
      request.write(jsonBody);

      HttpClientResponse response = await request.close();
      String responseBody = await response.transform(utf8.decoder).join();

      print("🔹 JSON gửi lên API: $jsonBody");
      print("🔹 Status code: ${response.statusCode}");
      print("🔹 Phản hồi từ API: $responseBody");

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print("❌ Lỗi API: $responseBody");
        return false;
      }
    } catch (e) {
      print("🚨 Lỗi kết nối API: $e");
      return false;
    }
  }
  Future<bool> deleteArticle(int articleId) async {
    try {
      final url = Uri.parse('$baseUrl/$articleId');

      HttpClient client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;

      HttpClientRequest request = await client.deleteUrl(url);
      request.headers.set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");

      HttpClientResponse response = await request.close();
      String responseBody = await response.transform(utf8.decoder).join();

      print("🔹 Xóa bài viết ID: $articleId");
      print("🔹 Status code: ${response.statusCode}");
      print("🔹 Phản hồi từ API: $responseBody");

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print("❌ Lỗi API: $responseBody");
        return false;
      }
    } catch (e) {
      print("🚨 Lỗi kết nối API: $e");
      return false;
    }
  }

}