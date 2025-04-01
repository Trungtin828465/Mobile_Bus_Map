import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Để chỉnh thanh trạng thái
import 'package:animate_do/animate_do.dart';
import 'signup.dart';
import 'package:project1/app/Them/Them.dart';
import 'package:project1/app/features/dashboard/widgets/custom_scaffold.dart';
import 'package:project1/app/features/dashboard/widgets/welcome_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Đặt màu thanh trạng thái trong suốt để gradient hiển thị xuyên qua
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return CustomScaffold(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4FC3F7), // Xanh dương nhạt
              Color(0xFF81C784), // Xanh lá nhạt
            ],
          ),
        ),
        child: Column(
          children: [
            Flexible(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeInDown(
                    duration: const Duration(milliseconds: 1000),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Welcome Back!\n',
                            style: TextStyle(
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          TextSpan(
                            text: 'Enter your details to access your account',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white70,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 4,
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeInUp(
                      duration: const Duration(milliseconds: 1200),
                      child: WelcomeButton(
                        buttonText: 'Sign In',
                        onTap: () {
                          Navigator.pushNamed(context, '/signin');
                        },
                        color: const Color(0xFFFFCA28),
                        textColor: const Color(0xFF0288D1), // Xanh dương đậm
                      ),
                    ),
                    // FadeInUp(
                    //   duration: const Duration(milliseconds: 1400),
                    //   child: WelcomeButton(
                    //     buttonText: 'Sign Up',
                    //     onTap: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(builder: (context) => const SignUpScreen()),
                    //       );
                    //     },
                    //     color: const Color(0xFFFFCA28), // Màu vàng nổi bật
                    //     textColor: Colors.black87,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}