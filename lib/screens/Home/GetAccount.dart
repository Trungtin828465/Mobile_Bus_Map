
import 'package:flutter/material.dart';
import 'package:busmap/models/LoginModel/GetAccountModel.dart';
import 'package:busmap/service/GetAccountService.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:busmap/Router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Account? account;
  bool isLoading = true;
  String? errorMessage;

  // Các controller nullable để tránh LateInitializationError
  TextEditingController? fullNameController;
  TextEditingController? emailController;
  TextEditingController? numberPhoneController;
  TextEditingController? passwordController;

  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndFetchAccount();
  }

  Future<void> _loadUserIdAndFetchAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('user_id');
    print('id ng dung$id');

    if (id != null) {
      setState(() {
        userId = id;
      });
      await fetchAccountData(id);
    } else {
      setState(() {
        errorMessage = "Không tìm thấy userId";
        isLoading = false;
      });
    }
  }
  // Hàm đăng xuất
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id'); // Xóa user_id khỏi SharedPreferences
    await prefs.remove('user_name'); // Xóa user_id khỏi SharedPreferences
    await prefs.remove('user_email'); // Xóa user_id khỏi SharedPreferences


    FluroRouterConfig.router.navigateTo(context, '/welcome', replace: true); // Chuyển hướng về Welcome screen
  }

  Future<void> fetchAccountData(int id) async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final accountService = AccountService();
      final fetchedAccount = await accountService.fetchAccount(id);

      setState(() {
        account = fetchedAccount;
        isLoading = false;

        fullNameController = TextEditingController(text: account!.fullName);
        emailController = TextEditingController(text: account!.email);
        numberPhoneController = TextEditingController(text: account!.numberPhone);
        passwordController = TextEditingController(text: account!.password);
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> showEditDialog(String title, TextEditingController controller) async {
    bool isPassword = title == 'Mật khẩu';

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chỉnh sửa $title'),
          content: TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(hintText: 'Nhập $title mới'),
            keyboardType: title == 'Số điện thoại' ? TextInputType.number : TextInputType.text,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Lưu'),
              onPressed: () {
                setState(() {
                  String newValue = controller.text;
                  if (title == 'Họ và tên') {
                    account!.fullName = newValue;
                  } else if (title == 'Email') {
                    account!.email = newValue;
                  } else if (title == 'Số điện thoại') {
                    account!.numberPhone = newValue;
                  } else if (title == 'Mật khẩu') {
                    account!.password = newValue;
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> updateAccount() async {
    String fullName = fullNameController?.text.trim() ?? '';
    String email = emailController?.text.trim() ?? '';
    String phone = numberPhoneController?.text.trim() ?? '';
    String password = passwordController?.text.trim() ?? '';

    if (fullName.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
      return;
    }

    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email không hợp lệ')),
      );
      return;
    }

    if (phone.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Số điện thoại phải đủ 10 chữ số')),
      );
      return;
    }

    try {
      final response = await http.put(
        Uri.parse('https://10.0.2.2:7222/api/accounts/update?id=$userId'),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'text/plain',
        },
        body: jsonEncode({
          'id': userId,
          'fullName': fullName,
          'email': email,
          'numberPhone': phone,
          'password': password,
          'tripHistories': {'\$values': []},
        }),
      );

      print("Update Status Code: ${response.statusCode}");
      print("Update Response Body: ${response.body}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật thông tin thành công')),
        );
      } else {
        final data = jsonDecode(response.body);
        String errorMessage = data.containsKey('message')
            ? data['message']
            : 'Lỗi không xác định khi cập nhật';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print("Update Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }


  @override
  void dispose() {
    fullNameController?.dispose();
    emailController?.dispose();
    numberPhoneController?.dispose();
    passwordController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () {
            FluroRouterConfig.router.navigateTo(context, '/homeMaster', replace: true);
          },
        ),
        title: Text(
          'Sửa hồ sơ $userId',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: Colors.green),
            onPressed: () {
              updateAccount();
            },
          ),

        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : account == null
          ? Center(child: Text('Không thể tải dữ liệu'))
          : SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.greenAccent,
              height: 150,
              child: Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey, // kiểm tra hình có load không

                      backgroundImage: AssetImage('assets/img/nam.jpg'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.camera_alt,
                          size: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text('Họ và tên'),
              subtitle: Text(account!.fullName),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                showEditDialog('Họ và tên', fullNameController!);
              },
            ),
            Divider(),
            ListTile(
              title: Text('Email'),
              subtitle: Text(account!.email),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                showEditDialog('Email', emailController!);
              },
            ),
            Divider(),
            ListTile(
              title: Text('Số điện thoại'),
              subtitle: Text(account!.numberPhone),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                showEditDialog('Số điện thoại', numberPhoneController!);
              },
            ),
            Divider(),
            ListTile(
              title: Text('Mật khẩu'),
              subtitle: Text('*' * (account!.password.length - 2) + account!.password.substring(account!.password.length - 2)),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                showEditDialog('Mật khẩu', passwordController!);
              },
            ),

            Divider(),
            // Thêm ListTile cho nút Đăng xuất ở dưới
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: Text('Đăng xuất', style: TextStyle(color: Colors.red)),
              onTap: () {
                logout();  // Gọi hàm đăng xuất khi nhấn
              },
            ),
            Divider(),
          ],
        ),
      ),

    );
  }
}
