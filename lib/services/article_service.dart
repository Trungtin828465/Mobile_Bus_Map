import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:busmap/models/article.dart';

class ArticleService {
  static const String baseUrl = 'https://10.0.2.2:7222/api/articles'; // Thay bằng URL API thực tế của bạn

  Future<List<Article>> getArticles() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load articles: Status ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error loading articles: $e');
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