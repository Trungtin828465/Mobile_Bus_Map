import 'dart:convert';
import 'dart:io';
import 'package:busmap/models/Admin/user_admin_chat.dart';
import 'package:busmap/models/Admin/user_admin_message.dart';

class UserAdminChatService {
  final String baseUrl = "https://10.0.2.2:7222/api/user-admin-chats";

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
    };
  }

  // Tạo HttpClient với bỏ qua kiểm tra SSL
  HttpClient _createHttpClient() {
    HttpClient client = HttpClient();
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return client;
  }

  // Tạo cuộc trò chuyện mới
  Future<UserAdminChat> createChat(int userId, int adminId) async {
    try {
      final headers = _getHeaders();
      final client = _createHttpClient();

      HttpClientRequest request = await client.postUrl(Uri.parse(baseUrl));
      headers.forEach((key, value) => request.headers.set(key, value));
      request.add(utf8.encode(jsonEncode({
        'userId': userId,
        'adminId': adminId,
      })));

      HttpClientResponse response = await request.close();
      String jsonResponse = await response.transform(utf8.decoder).join();

      print("API Response Status (createChat): ${response.statusCode}");
      print("API Response Body (createChat): $jsonResponse");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserAdminChat.fromJson(json.decode(jsonResponse));
      } else {
        try {
          final errorBody = json.decode(jsonResponse);
          throw Exception(errorBody['message'] ?? 'Lỗi không xác định từ server: ${response.statusCode}');
        } catch (e) {
          throw Exception('Lỗi server: ${response.statusCode} - $jsonResponse');
        }
      }
    } catch (e) {
      throw Exception("Lỗi khi tạo cuộc trò chuyện: $e");
    }
  }

  // Lấy danh sách cuộc trò chuyện theo userId
  // Future<List<UserAdminChat>> getChatsByUserId(int userId) async {
  //   try {
  //     final headers = _getHeaders();
  //     final client = _createHttpClient();
  //
  //     HttpClientRequest request = await client.getUrl(Uri.parse('$baseUrl/user/$userId'));
  //     headers.forEach((key, value) => request.headers.set(key, value));
  //
  //     HttpClientResponse response = await request.close();
  //     String jsonResponse = await response.transform(utf8.decoder).join();
  //
  //     print("API Response Status (getChatsByUserId): ${response.statusCode}");
  //     print("API Response Body (getChatsByUserId): $jsonResponse");
  //
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> jsonData = json.decode(jsonResponse);
  //       final List<dynamic> jsonList = jsonData['\$values'] ?? [];
  //       return jsonList.map((json) => UserAdminChat.fromJson(json)).toList();
  //     } else if (response.statusCode == 404) {
  //       return [];
  //     } else {
  //       try {
  //         final errorBody = json.decode(jsonResponse);
  //         throw Exception(errorBody['message'] ?? 'Lỗi không xác định từ server: ${response.statusCode}');
  //       } catch (e) {
  //         throw Exception('Lỗi server: ${response.statusCode} - $jsonResponse');
  //       }
  //     }
  //   } catch (e) {
  //     print("Error in getChatsByUserId: $e");
  //     throw Exception("Lỗi khi lấy danh sách cuộc trò chuyện: $e");
  //   }
  // }
  Future<List<UserAdminChat>> getChatsByUserId(int userId) async {
    try {
      final headers = _getHeaders();
      final client = _createHttpClient();

      HttpClientRequest request = await client.getUrl(Uri.parse('$baseUrl/user/$userId'));
      headers.forEach((key, value) => request.headers.set(key, value));

      HttpClientResponse response = await request.close();
      String jsonResponse = await response.transform(utf8.decoder).join();

      print("API Response Status (getChatsByUserId): ${response.statusCode}");
      print("API Response Body (getChatsByUserId): $jsonResponse");

      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(jsonResponse);
        if (jsonData is List) {
          // API trả về danh sách trực tiếp
          return jsonData.map((json) => UserAdminChat.fromJson(json)).toList();
        } else if (jsonData is Map<String, dynamic> && jsonData.containsKey('\$values')) {
          // API trả về đối tượng với "$values"
          final List<dynamic> jsonList = jsonData['\$values'] ?? [];
          return jsonList.map((json) => UserAdminChat.fromJson(json)).toList();
        } else {
          throw Exception("Dữ liệu trả về không đúng định dạng mong đợi: $jsonResponse");
        }
      } else if (response.statusCode == 404) {
        return [];
      } else {
        try {
          final errorBody = json.decode(jsonResponse);
          throw Exception(errorBody['message'] ?? 'Lỗi không xác định từ server: ${response.statusCode}');
        } catch (e) {
          throw Exception('Lỗi server: ${response.statusCode} - $jsonResponse');
        }
      }
    } catch (e) {
      print("Error in getChatsByUserId: $e");
      throw Exception("Lỗi khi lấy danh sách cuộc trò chuyện: $e");
    }
  }
  // Lấy danh sách cuộc trò chuyện theo adminId (Mới)
  // Future<List<UserAdminChat>> getChatsByAdminId(int adminId) async {
  //   try {
  //     final headers = _getHeaders();
  //     final client = _createHttpClient();
  //
  //     HttpClientRequest request = await client.getUrl(Uri.parse('$baseUrl/admin/$adminId'));
  //     headers.forEach((key, value) => request.headers.set(key, value));
  //
  //     HttpClientResponse response = await request.close();
  //     String jsonResponse = await response.transform(utf8.decoder).join();
  //
  //     print("API Response Status (getChatsByAdminId): ${response.statusCode}");
  //     print("API Response Body (getChatsByAdminId): $jsonResponse");
  //
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> jsonData = json.decode(jsonResponse);
  //       final List<dynamic> jsonList = jsonData['\$values'] ?? []; // Lấy danh sách từ trường $values
  //       return jsonList.map((json) => UserAdminChat.fromJson(json)).toList();
  //     } else if (response.statusCode == 404) {
  //       return [];
  //     } else {
  //       try {
  //         final errorBody = json.decode(jsonResponse);
  //         throw Exception(errorBody['message'] ?? 'Lỗi không xác định từ server: ${response.statusCode}');
  //       } catch (e) {
  //         throw Exception('Lỗi server: ${response.statusCode} - $jsonResponse');
  //       }
  //     }
  //   } catch (e) {
  //     throw Exception("Lỗi khi lấy danh sách cuộc trò chuyện theo adminId: $e");
  //   }
  // }
  Future<List<UserAdminChat>> getChatsByAdminId(int adminId) async {
    try {
      final headers = _getHeaders();
      final client = _createHttpClient();

      HttpClientRequest request = await client.getUrl(Uri.parse('$baseUrl/admin/$adminId'));
      headers.forEach((key, value) => request.headers.set(key, value));

      HttpClientResponse response = await request.close();
      String jsonResponse = await response.transform(utf8.decoder).join();

      print("API Response Status (getChatsByAdminId): ${response.statusCode}");
      print("API Response Body (getChatsByAdminId): $jsonResponse");

      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(jsonResponse);
        if (jsonData is List) {
          // API trả về danh sách trực tiếp
          return jsonData.map((json) => UserAdminChat.fromJson(json)).toList();
        } else if (jsonData is Map<String, dynamic> && jsonData.containsKey('\$values')) {
          // API trả về đối tượng với "$values"
          final List<dynamic> jsonList = jsonData['\$values'] ?? [];
          return jsonList.map((json) => UserAdminChat.fromJson(json)).toList();
        } else {
          throw Exception("Dữ liệu trả về không đúng định dạng mong đợi: $jsonResponse");
        }
      } else if (response.statusCode == 404) {
        return [];
      } else {
        try {
          final errorBody = json.decode(jsonResponse);
          throw Exception(errorBody['message'] ?? 'Lỗi không xác định từ server: ${response.statusCode}');
        } catch (e) {
          throw Exception('Lỗi server: ${response.statusCode} - $jsonResponse');
        }
      }
    } catch (e) {
      print("Error in getChatsByAdminId: $e");
      throw Exception("Lỗi khi lấy danh sách cuộc trò chuyện theo adminId: $e");
    }
  }
  // Gửi tin nhắn
  Future<UserAdminMessage> sendMessage(String chatId, String senderRole, String content) async {
    try {
      final headers = _getHeaders();
      final client = _createHttpClient();

      HttpClientRequest request = await client.postUrl(Uri.parse('$baseUrl/message'));
      headers.forEach((key, value) => request.headers.set(key, value));
      request.add(utf8.encode(jsonEncode({
        'chatId': chatId,
        'senderRole': senderRole,
        'content': content,
      })));

      HttpClientResponse response = await request.close();
      String jsonResponse = await response.transform(utf8.decoder).join();

      print("API Response Status (sendMessage): ${response.statusCode}");
      print("API Response Body (sendMessage): $jsonResponse");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserAdminMessage.fromJson(json.decode(jsonResponse));
      } else {
        try {
          final errorBody = json.decode(jsonResponse);
          throw Exception(errorBody['message'] ?? 'Lỗi không xác định từ server: ${response.statusCode}');
        } catch (e) {
          throw Exception('Lỗi server: ${response.statusCode} - $jsonResponse');
        }
      }
    } catch (e) {
      throw Exception("Lỗi khi gửi tin nhắn: $e");
    }
  }

  Future<List<UserAdminMessage>> getMessagesByChatId(String chatId) async {
    try {
      final headers = _getHeaders();
      final client = _createHttpClient();

      HttpClientRequest request = await client.getUrl(Uri.parse('$baseUrl/$chatId/messages'));
      headers.forEach((key, value) => request.headers.set(key, value));

      HttpClientResponse response = await request.close();
      String jsonResponse = await response.transform(utf8.decoder).join();

      print("API Response Status (getMessagesByChatId): ${response.statusCode}");
      print("API Response Body (getMessagesByChatId): $jsonResponse");

      if (response.statusCode == 200) {
        final dynamic decodedResponse = json.decode(jsonResponse);
        if (decodedResponse is Map<String, dynamic> && decodedResponse.containsKey('\$values')) {
          final List<dynamic> messageList = decodedResponse['\$values'] ?? [];
          return messageList.map((json) => UserAdminMessage.fromJson(json)).toList();
        } else if (decodedResponse is List) {
          return decodedResponse.map((json) => UserAdminMessage.fromJson(json)).toList();
        } else {
          throw Exception("Dữ liệu trả về không phải là danh sách tin nhắn: $jsonResponse");
        }
      } else if (response.statusCode == 404) {
        return [];
      } else {
        try {
          final errorBody = json.decode(jsonResponse);
          throw Exception(errorBody['message'] ?? 'Lỗi không xác định từ server: ${response.statusCode}');
        } catch (e) {
          throw Exception('Lỗi server: ${response.statusCode} - $jsonResponse');
        }
      }
    } catch (e) {
      throw Exception("Lỗi khi lấy danh sách tin nhắn: $e");
    }
  }

  Future<bool> markMessageAsRead(String chatId, String readerRole) async {

    final headers = _getHeaders();
    final client = _createHttpClient();

    HttpClientRequest request = await client.putUrl(Uri.parse('$baseUrl/chat/$chatId/mark-read?readerRole=$readerRole'));
    headers.forEach((key, value) => request.headers.set(key, value));

    HttpClientResponse response = await request.close();
    String jsonResponse = await response.transform(utf8.decoder).join();

    print("API Response Status (markMessageAsRead): ${response.statusCode}");
    print("API Response Body (markMessageAsRead): $jsonResponse");



    return true;


  }
  // Xóa cuộc trò chuyện
  Future<bool> deleteChat(String chatId) async {
    try {
      final headers = _getHeaders();
      final client = _createHttpClient();

      HttpClientRequest request = await client.deleteUrl(Uri.parse('$baseUrl/$chatId'));
      headers.forEach((key, value) => request.headers.set(key, value));

      HttpClientResponse response = await request.close();
      String jsonResponse = await response.transform(utf8.decoder).join();

      print("API Response Status (deleteChat): ${response.statusCode}");
      print("API Response Body (deleteChat): $jsonResponse");

      if (response.statusCode == 204) {
        return true;
      } else {
        try {
          final errorBody = json.decode(jsonResponse);
          throw Exception(errorBody['message'] ?? 'Lỗi không xác định từ server: ${response.statusCode}');
        } catch (e) {
          throw Exception('Lỗi server: ${response.statusCode} - $jsonResponse');
        }
      }
    } catch (e) {
      throw Exception("Lỗi khi xóa cuộc trò chuyện: $e");
    }
  }
}

