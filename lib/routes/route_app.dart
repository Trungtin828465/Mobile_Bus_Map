import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:utilitybus/views/map_screen.dart';
import 'package:utilitybus/views/trip_screen.dart';

class FluroRouterConfig {
  static final FluroRouter router = FluroRouter();

  // Định nghĩa route
  static void defineRoutes() {
    router.define(
      "/mapsreecs",
      handler: Handler(handlerFunc: (context, params) => MapScreen()),
    );

    router.define(
      "/triplist",
      handler: Handler(handlerFunc: (context, params) {
        final start = params['start']?.first ?? "";
        final end = params['end']?.first ?? "";

        return BusRouteFinderView(
          initialFrom: start,
          initialTo: end,
        );
      }),
    );

  }


  // Điều hướng với hiệu ứng trượt
  static void navigateToPage(BuildContext context, String route, {bool slideFromRight = true}) {
    router.navigateTo(
      context,
      route,
      transition: TransitionType.custom,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return _customPageTransition(context, animation, secondaryAnimation, child, slideFromRight);
      },
      transitionDuration: Duration(milliseconds: 400),
    );
  }

  // Hiệu ứng trượt tùy chọn
  static Widget _customPageTransition(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child, bool slideFromRight) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: slideFromRight ? Offset(1.0, 0.0) : Offset(-1.0, 0.0), // Phải -> trái hoặc trái -> phải
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
      child: FadeTransition(
        opacity: Tween<double>(
          begin: 0.3,
          end: 1.0,
        ).animate(animation),
        child: child,
      ),
    );
  }
}
