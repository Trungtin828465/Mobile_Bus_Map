import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:busmap/models/LoginModel/GetAccountModel.dart';

class AccountService {
  static const String baseUrl = "https://10.0.2.2:7222/api/accounts";

  // Hàm lấy thông tin tài khoản theo ID
  Future<Account> fetchAccount(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/id?id=$id'),
        headers: {'accept': 'text/plain'},
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Account.fromJson(data);
      } else {
        final data = jsonDecode(response.body);
        String errorMessage = data.containsKey('message')
            ? data['message']
            : 'Lỗi không xác định khi lấy thông tin tài khoản';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('');
    }
  }
}