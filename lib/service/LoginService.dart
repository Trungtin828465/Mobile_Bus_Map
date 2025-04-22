import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:busmap/models/LoginModel/RegisterModel.dart';
import 'package:busmap/models/LoginModel/LoginModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class ApiServiceLogin {
  final String baseUrl ="https://10.0.2.2:7222/api/accounts"; // Đổi cổng đúng với API

  // Đăng nhập cumsatomer
  Future<String> login(LoginModel loginModel) async {
    String? validateError = loginModel.validate();
    if (validateError != null) {
      throw Exception(validateError);
    }
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginModel.toJson()),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        String userEmail = data['account']['Email'] ?? '';
        String userName = data['account']['FullName'] ?? '';
        int userId = data['account']['Id'] ?? 0;

        // Lưu thông tin vào SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', userEmail);
        await prefs.setInt('user_id', userId); // <-- Thêm dòng này
        await prefs.setString('user_name', userName); // <-- Thêm dòng này
        return "Đăng nhập thành công. Tài khoảng: $userName";
      }
      else {
        String errorMessage =
        data.containsKey('message')
            ? data['message']
            : 'Lỗi đăng nhập không xác định';
        throw Exception(errorMessage);
      }
    } on SocketException {
      print("Lỗi kết nối mạng");
      throw Exception("Không thể kết nối đến máy chủ. Vui lòng kiểm tra mạng.");
    } on FormatException {
      print("Lỗi định dạng JSON");
      throw Exception("Dữ liệu phản hồi không đúng định dạng.");
    } catch (e) {
      print("Lỗi không xác định: $e");
      throw Exception(e.toString());
    }
  }

  Future<String> loginAdmin(LoginModel loginModel) async {
    String? validateError = loginModel.validate();
    if (validateError != null) {
      throw Exception(validateError);
    }
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Login Admin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginModel.toJson()),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {

        String fullName = data['accountAdmin']['FullName'] ?? 'khong co admin';
        int adminId = data['accountAdmin']['Id'] as int? ?? 0;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name', fullName);
        await prefs.setInt('admin_id', adminId);
        String userEmail = data['accountAdmin']['email'] ?? '';
        return "Đăng nhập thành công. Email admin: $userEmail";
      } else {
        throw Exception('');
      }
    } catch (e) {
      throw Exception('');
    }
  }

  // Đăng ký
  Future<String> register(RegisterModel registerModel) async {
    String? validationError = registerModel.validate();
    if (validationError != null) {
      throw Exception(validationError);
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(registerModel.toJson()),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return data['message'] ?? 'Đăng ký thành công';
      } else {
        // Nếu API trả về lỗi có chứa 'message', lấy thông báo đó
        String errorMessage =
        data.containsKey('message')
            ? data['message']
            : 'Lỗi đăng ký không xác định';

        throw Exception(errorMessage);
      }
    } on SocketException {
      print("Lỗi kết nối mạng");
      throw Exception("Không thể kết nối đến máy chủ. Vui lòng kiểm tra mạng.");
    } on FormatException {
      print("Lỗi định dạng JSON");
      throw Exception("Dữ liệu phản hồi không đúng định dạng.");
    } catch (e) {
      print("Lỗi không xác định: $e");
      throw Exception(e.toString()); // lỗi api
    }
  }
// goi otp
  Future<String> sendOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Send-OTP'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'Email': email}),
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception("Yêu cầu hết thời gian. Vui lòng thử lại.");
      });

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return responseBody['message'] ?? "OTP đã được gửi đến $email";
      } else {
        throw Exception(responseBody['message'] ?? 'Lỗi không xác định từ server: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception("Không thể kết nối đến máy chủ. Vui lòng kiểm tra mạng.");
    } on FormatException {
      throw Exception("Dữ liệu phản hồi không đúng định dạng.");
    } catch (e) {
      throw Exception("Lỗi $e");
    }
  }

  // Đổi mật khẩu (bao gồm xác nhận OTP)
  Future<String> changePassword(String email, String otp, String newPassword, String confirmPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ChangePassword'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Email': email,
          'OTP': otp,
          'NewPassword': newPassword,
          'ConfirmPassword': confirmPassword,
        }),
      );
      return "Đổi mật khẩu thành công! ";
    } on SocketException {
      throw Exception("Không thể kết nối đến máy chủ. Vui lòng kiểm tra mạng.");
    } on FormatException {
      throw Exception("Dữ liệu phản hồi không đúng định dạng.");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // XG
  // Xử lý phản hồi chung
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
        json.decode(response.body)['message'] ?? 'Lỗi không xác định',
      );
    }
  }
}
