import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:busmap/models/UserAdminChat/user_admin_chat.dart';
import 'package:busmap/models/UserAdminChat/user_admin_message.dart';

class UserAdminChatService {
  final String baseUrl = "https://10.0.2.2:7222/api/user-admin-chats"; // Thay đổi nếu cần

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

  // Tạo cuộc trò chuyện mới
  Future<UserAdminChat> createChat(int userId, int adminId) async {
    try {
      final headers = _getHeaders();
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode({
          'userId': userId,
          'adminId': adminId,
        }),
      );

      final jsonResponse = _handleResponse(response);
      return UserAdminChat.fromJson(jsonResponse);
    } catch (e) {
      throw Exception("Lỗi khi tạo cuộc trò chuyện: $e");
    }
  }

  // Lấy danh sách cuộc trò chuyện theo userId
  Future<List<UserAdminChat>> getChatsByUserId(int userId) async {
    try {
      final headers = _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/user/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => UserAdminChat.fromJson(json)).toList();
      } else {
        try {
          final errorBody = json.decode(response.body);
          throw Exception(errorBody['message'] ?? 'Lỗi không xác định từ server: ${response.statusCode}');
        } catch (e) {
          throw Exception('Lỗi server: ${response.statusCode} - ${response.body}');
        }
      }
    } catch (e) {
      throw Exception("Lỗi khi lấy danh sách cuộc trò chuyện: $e");
    }
  }

  // Gửi tin nhắn
  Future<UserAdminMessage> sendMessage(String chatId, String senderRole, String content) async {
    try {
      final headers = _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/message'),
        headers: headers,
        body: jsonEncode({
          'chatId': chatId,
          'senderRole': senderRole,
          'content': content,
        }),
      );

      final jsonResponse = _handleResponse(response);
      return UserAdminMessage.fromJson(jsonResponse);
    } catch (e) {
      throw Exception("Lỗi khi gửi tin nhắn: $e");
    }
  }

  // Lấy tin nhắn theo chatId
  Future<List<UserAdminMessage>> getMessagesByChatId(String chatId) async {
    try {
      final headers = _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/$chatId/messages'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => UserAdminMessage.fromJson(json)).toList();
      } else {
        try {
          final errorBody = json.decode(response.body);
          throw Exception(errorBody['message'] ?? 'Lỗi không xác định từ server: ${response.statusCode}');
        } catch (e) {
          throw Exception('Lỗi server: ${response.statusCode} - ${response.body}');
        }
      }
    } catch (e) {
      throw Exception("Lỗi khi lấy danh sách tin nhắn: $e");
    }
  }

  // Đánh dấu tin nhắn đã đọc
  Future<bool> markMessageAsRead(String chatId, String readerRole) async {
    try {
      final headers = _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/chat/$chatId/mark-read?readerRole=$readerRole'),
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
      throw Exception("Lỗi khi đánh dấu tin nhắn đã đọc: $e");
    }
  }

  // Xóa cuộc trò chuyện
  Future<bool> deleteChat(String chatId) async {
    try {
      final headers = _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/$chatId'),
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
      throw Exception("Lỗi khi xóa cuộc trò chuyện: $e");
    }
  }
}