import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../models/accounts.dart';
import '../models/Register.dart';
import '../models/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ApiService {
  final String apiUrl = "https://10.0.2.2:7017/api/accounts";

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
  Future<String> login(LoginModel loginModel) async {
    String? validateError = loginModel.validate();
    if (validateError != null) {
      throw Exception(validateError);
    }

    try {
      // Tạo HttpClient và bỏ qua kiểm tra chứng chỉ SSL
      HttpClient client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;

      // Tạo yêu cầu POST
      HttpClientRequest request = await client.postUrl(Uri.parse('$apiUrl/Login'));
      request.headers.set('Content-Type', 'application/json');

      // Gửi dữ liệu JSON
      String body = jsonEncode(loginModel.toJson());
      request.write(body);

      // Đóng yêu cầu và nhận phản hồi
      HttpClientResponse response = await request.close();
      String jsonResponse = await response.transform(utf8.decoder).join();

      // Kiểm tra mã trạng thái
      print("Status Code: ${response.statusCode}");
      print("Response Body: $jsonResponse");

      final data = jsonDecode(jsonResponse) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final account = data['account'] as Map<String, dynamic>?;
        if (account == null) {
          throw Exception("Phản hồi thiếu thông tin tài khoản");
        }

        String Email = account['email'] as String? ?? '';
        String Name = account['fullName'] as String? ?? ''; // Lấy name từ API
        int adminId = account['id'] as int? ?? 0; // Lấy admin_id từ API
        if (Email.isEmpty) {
          throw Exception("Email tài khoản không hợp lệ hoặc thiếu");
        }

        // Kiểm tra email có đuôi @admin.utc2 không
        const adminDomain = '@admin.utc2';
        if (!Email.endsWith(adminDomain)) {
          throw Exception("Email không có quyền truy cập trang admin. Chỉ email @admin.utc2 mới được phép.");
        }

        // Lưu email và name vào SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', Email);
        await prefs.setString('name', Name);
        await prefs.setInt('admin_id', adminId); // Lưu admin_id
        return data['message'] as String? ?? 'Đăng nhập thành công';
      } else {
        String errorMessage = data['message'] as String? ?? 'Lỗi đăng nhập không xác định';
        throw Exception(errorMessage);
      }
    } on SocketException {
      print("SocketException: Không thể kết nối");
      throw Exception("Không thể kết nối đến máy chủ. Vui lòng kiểm tra mạng.");
    } on FormatException {
      print("FormatException: Lỗi định dạng JSON");
      throw Exception("Dữ liệu phản hồi không đúng định dạng.");
    } catch (e) {
      print("Lỗi không xác định: $e");
      throw Exception("Lỗi: $e");
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
        Uri.parse('$apiUrl/Register'),
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
        String errorMessage = data.containsKey('message')
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




  // Gửi OTP
  Future<Map<String, dynamic>> sendOtp(String email) async {
    final response = await http.post(
      Uri.parse('$apiUrl/Send-OTP'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'Email': email}),
    );
    return _handleResponse(response);
  }

  // Đổi mật khẩu sau khi nhập OTP
  Future<Map<String, dynamic>> changePassword(String email, String otp, String newPassword, String confirmPassword) async {
    final response = await http.post(
      Uri.parse('$apiUrl/ChangePassword'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'Email': email,
        'OTP': otp,
        'NewPassword': newPassword,
        'ConfirmPassword': confirmPassword
      }),
    );
    return _handleResponse(response);
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
