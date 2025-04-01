import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:animate_do/animate_do.dart';
import 'signup.dart';
import 'package:project1/app/features/dashboard/widgets/custom_scaffold.dart';
import 'package:project1/app/features/dashboard/widgets/SuccessDialog.dart';
import 'package:project1/app/Them/Them.dart';
import 'package:project1/app/models/Login.dart';
import 'package:project1/app/services/api_account.dart';
import 'package:fluro/fluro.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with SingleTickerProviderStateMixin {
  final FluroRouter router = FluroRouter();
  final _formSignInKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  bool rememberPassword = true;
  bool _obscureText = true;

  late AnimationController _busAnimationController;
  late Animation<double> _busAnimation;

  @override
  void initState() {
    super.initState();
    _busAnimationController = AnimationController(
      duration: const Duration(seconds: 3), // Thời gian xe buýt di chuyển từ phải sang trái
      vsync: this,
    );

    _busAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _busAnimationController,
        curve: Curves.linear,
      ),
    );

    // Reset animation khi xe buýt biến mất hoàn toàn
    _busAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _busAnimationController.reset(); // Reset để xe buýt xuất hiện lại ở bên phải
        _busAnimationController.forward(); // Bắt đầu lại animation
      }
    });

    _busAnimationController.forward(); // Bắt đầu animation
  }

  @override
  void dispose() {
    _busAnimationController.dispose();
    emailController.dispose();
    passWordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // Lấy chiều rộng màn hình
    final screenWidth = MediaQuery.of(context).size.width;
    const busWidth = 350.0; // Chiều rộng của xe buýt

    return CustomScaffold(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4FC3F7),
              Color(0xFF81C784),
            ],
          ),
        ),
        child: Column(
          children: [
            const Expanded(flex: 1, child: SizedBox(height: 10)),
            Expanded(
              flex: 7,
              child: Container(
                padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formSignInKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FadeInDown(
                          duration: const Duration(milliseconds: 800),
                          child: Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0288D1),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40.0),
                        FadeInDown(
                          duration: const Duration(milliseconds: 1000),
                          child: TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Email';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter Email',
                              hintStyle: const TextStyle(color: Colors.black26),
                              prefixIcon: const Icon(Icons.email, color: Colors.grey),
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xFF0288D1)),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        FadeInDown(
                          duration: const Duration(milliseconds: 1200),
                          child: TextFormField(
                            controller: passWordController,
                            obscureText: _obscureText,
                            obscuringCharacter: '*',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Password';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter Password',
                              hintStyle: const TextStyle(color: Colors.black26),
                              prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xFF0288D1)),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        FadeInDown(
                          duration: const Duration(milliseconds: 1400),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: rememberPassword,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        rememberPassword = value!;
                                      });
                                    },
                                    activeColor: const Color(0xFF0288D1),
                                  ),
                                  const Text('Remember me', style: TextStyle(color: Colors.black45)),
                                ],
                              ),
                              GestureDetector(
                                child: const Text(
                                  'Forget password?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0288D1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formSignInKey.currentState!.validate() && rememberPassword) {
                                  try {
                                    LoginModel user = LoginModel(
                                      email: emailController.text.trim(),
                                      password: passWordController.text.trim(),
                                    );

                                    String responseMessage = await ApiService().login(user);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(responseMessage)),
                                    );
                                    await showDialog(
                                      context: context,
                                      builder: (context) => SuccessDialog(message: responseMessage),
                                    );

                                    if (mounted) {
                                      Navigator.pushReplacementNamed(context, '/dashboard');
                                    }
                                  } catch (e) {
                                    print("Lỗi đăng nhập: $e");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Đăng nhập thất bại: $e')),
                                    );
                                  }
                                } else if (!rememberPassword) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Vui lòng đồng ý lưu thông tin đăng nhập')),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0288D1),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 5,
                              ),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        // Thêm xe buýt chuyển động
                        SizedBox(
                          height: 300,
                          child: AnimatedBuilder(
                            animation: _busAnimation,
                            builder: (context, child) {
                              // Tính toán vị trí của xe buýt
                              final offset = (busWidth / screenWidth) * 2; // Offset để xe buýt biến mất hoàn toàn
                              final alignmentX = 1 - (2 + offset) * _busAnimation.value; // Di chuyển từ 1 đến -(1 + offset)

                              return Align(
                                alignment: Alignment(alignmentX, 0),
                                child: child,
                              );
                            },
                            child: Image.asset(
                              'lib/app/images/bus.png',
                              height: 250,
                              width: 350,
                            ),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}