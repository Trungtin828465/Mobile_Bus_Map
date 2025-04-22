import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:busmap/models/Khanh/ChatBot/chat_model.dart';
import 'package:busmap/models/Khanh/ChatBot/detail_chat_model.dart';

class ChatApiService {

  final String baseUrl =
      "https://10.0.2.2:7222/api"; // Đổi cổng đúng với API
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
    };
  }

  Future<ChatModel> createChat(int userId, String title) async {
    final headers = _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/chats'),
      headers: headers,
      body: jsonEncode({
        'userId': userId,
        'title': title,
      }),
    );
    final jsonResponse = _handleResponse(response);
    return ChatModel.fromJson(jsonResponse);
  }

  Future<List<ChatModel>> getChatsByUserId(int userId) async {
    final headers = _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/chats/user/$userId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ChatModel.fromJson(json)).toList();
    } else {
      try {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Lỗi không xác định từ server: ${response.statusCode}');
      } catch (e) {
        throw Exception('Lỗi server: ${response.statusCode} - ${response.body}');
      }
    }
  }

  Future<List<DetailChatModel>> getDetailChatById(String chatId, {int page = 1, int pageSize = 20}) async {
    final headers = _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/chats/$chatId/details?page=$page&pageSize=$pageSize'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => DetailChatModel.fromJson(json)).toList();
    } else {
      try {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Lỗi không xác định từ server: ${response.statusCode}');
      } catch (e) {
        throw Exception('Lỗi server: ${response.statusCode} - ${response.body}');
      }
    }
  }

  Future<void> deleteChat(String chatId) async {
    final headers = _getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/chats/$chatId'),
      headers: headers,
    );

    if (response.statusCode != 204) {
      throw Exception(json.decode(response.body)['message'] ?? 'Failed to delete chat');
    }
  }

  Future<DetailChatModel> postRequestChat(String chatId, String role, String content) async {
    final headers = _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/chats/request'),
      headers: headers,
      body: jsonEncode({
        'chatId': chatId,
        'role': role,
        'content': content,
      }),
    );
    final jsonResponse = _handleResponse(response);
    return DetailChatModel.fromJson(jsonResponse);
  }

  Future<ChatModel> updateChatTitle(String chatId, String newTitle) async {
    // Kiểm tra đầu vào
    if (chatId.isEmpty) {
      throw Exception("Chat ID không được để trống.");
    }
    if (newTitle.trim().isEmpty) {
      throw Exception("Tiêu đề không được để trống.");
    }

    try {
      final headers = _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/chats/$chatId'),
        headers: headers,
        body: jsonEncode({
          'title': newTitle.trim(), // Loại bỏ khoảng trắng thừa
        }),
      );

      final jsonResponse = _handleResponse(response);
      return ChatModel.fromJson(jsonResponse);
    } catch (e) {
      if (e.toString().contains("404")) {
        throw Exception("Chat không tồn tại.");
      } else if (e.toString().contains("400")) {
        throw Exception("Yêu cầu không hợp lệ: $e");
      } else {
        throw Exception("Lỗi khi cập nhật tiêu đề chat: $e");
      }
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
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
}