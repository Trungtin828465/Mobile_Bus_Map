// import 'package:busmap/screens/RouterBusStop/DetailBus.dart';
// import 'package:busmap/screens/RouterBusStop/MapGpsSearch.dart';
// import 'package:fluro/fluro.dart';  // Import Fluro
// import 'package:busmap/screens/HomePage.dart';
// import 'package:busmap/screens/Map/MapGps.dart';
// import 'package:busmap/screens/RouterBusStop/SelectRoute.dart';
// import 'package:busmap/screens/Admin/admin.dart';
// import 'package:busmap/screens/Notification/notification_screen.dart';
// import 'package:busmap/screens/Favorite/favorite_screen.dart';
// import 'package:busmap/screens/Home/home_screen.dart';
// import 'package:busmap/main.dart';
// import 'package:flutter/material.dart'; // Import BusMapApp
// class FluroRouterConfig {
//   static final FluroRouter router = FluroRouter();
//
//   // router gốc
//   static final Handler _rootHandler = Handler(
//     handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
//       return  BusMapApp();
//     },
//   );
//   static final Handler _homeHandler = Handler(
//     handlerFunc: (context, params) => HomeContent(),
//   );
//   static final Handler _admin = Handler(
//     handlerFunc: (context, params) => AccountManagementScreen(),
//   );
//
//   static final Handler _selectRoute = Handler(
//     handlerFunc: (context, params) => SelectRount(),
//   );
//   static final Handler _mapSearch = Handler(
//     handlerFunc: (context, params) => MapGpsSearch(),
//   );
//   static final Handler _map = Handler(
//     handlerFunc: (context, params) => MapGps(),
//   );
//   static final Handler _busDetailHandler = Handler(
//     handlerFunc: (context, params) {
//       final routeId = params['routeId']?.first;  // Lấy routeId từ URL
//       return BusDetailScreen(routeId: routeId ?? '');
//     },
//   );
//   // dung
//
//
//
//   static void setupRouter() {
//     router.define(
//       '/', // Route gốc
//       handler: _rootHandler,
//     );
//     router.define("/home", handler: _homeHandler);
//     router.define("/admin", handler: _admin);
//     router.define("/selectRouter", handler: _selectRoute);
//     router.define("/mapSearch", handler: _mapSearch);
//     router.define("/map", handler: _map);
//
//     router.define("/busDetail/:routeId", handler: _busDetailHandler);  // 🔥 Thêm router mới
//
//   }
// }
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:busmap/main.dart'; // Import BusMapApp
import 'package:busmap/screens/Home/home_screen.dart';
import 'package:busmap/screens/Home/user_chat_list_admin_screen.dart';
import 'package:busmap/screens/Login/welcome_screen.dart';

import 'package:busmap/screens/Admin/user_admin_chat_list_screen.dart';
import 'package:busmap/screens/Admin/admin.dart'; // Import AccountManagementScreen
import 'package:busmap/screens/Notification/notification_screen.dart'; // Nếu cần
import 'package:busmap/screens/Favorite/favorite_screen.dart'; // Nếu cần
import 'package:busmap/screens/RouterBusStop/SelectRoute.dart'; // Import SelectRount
import 'package:busmap/screens/RouterBusStop/MapGpsSearch.dart'; // Import MapGpsSearch
import 'package:busmap/screens/Map/MapGps.dart'; // Import MapGps
import 'package:busmap/screens/RouterBusStop/DetailBus.dart'; // Import BusDetailScreen
import 'package:busmap/screens/Dung/FindWay.dart'; // Import FindWay
import 'package:busmap/screens/Dung/BusRouteFinder.dart'; // Import BusRouteFinder
import 'package:busmap/screens/Home/HomeMasterScreen.dart';
class FluroRouterConfig {
  static final FluroRouter router = FluroRouter();

 // Handler cho route gốc
  static final Handler _rootHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return  BusMapApp();
    },
  );
  // static final Handler _usrAdminChat = Handler(
  //   handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  //     return  UserChatUserListScreen();
  //   },
  // );
  // Handler cho Homemaster
  static final Handler _homeMasterHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return  HomeMaster();
    },
  );
  // Handler cho HomeContent
  static final Handler _homeHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return  HomeContent();
    },
  );

  // Handler cho AccountManagementScreen
  static final Handler _adminHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return const AccountManagementScreen();
    },
  );

  // Handler cho SelectRount
  static final Handler _selectRouteHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return  SelectRount();
    },
  );

  // Handler cho MapGpsSearch
  static final Handler _mapSearchHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return  MapGpsSearch();
    },
  );

  // Handler cho MapGps
  static final Handler _mapHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return  MapGps();
    },
  );

  // Handler cho BusDetailScreen
  static final Handler _busDetailHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      final routeId = params['routeId']?.first ?? '';
      return BusDetailScreen(routeId: routeId);
    },
  );

  // Handler cho FindWay (từ code mới)
  static final Handler _mapScreenHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return  FindWay();
    },
  );
  // Handler cho Welcome
  static final Handler _welcomeHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return  WelcomeScreen();
    },
  );

  // Handler cho BusRouteFinder (từ code mới)
  static final Handler _listBusHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      final start = params['start']?.first ?? '';
      final end = params['end']?.first ?? '';
      return BusRouteFinder(
        initialFrom: start,
        initialTo: end,
      );
    },
  );

  static void setupRouter() {
    router.define(
      '/', // Route gốc
      handler: _rootHandler,
    );

    router.define(
      '/home',
      handler: _homeHandler,
    );
    router.define(
      '/homeMaster',
      handler: _homeMasterHandler,
    );
    router.define(
      '/admin',
      handler: _adminHandler,
    );
    router.define(
      '/selectRouter',
      handler: _selectRouteHandler,
    );
    router.define(
      '/mapSearch',
      handler: _mapSearchHandler,
    );
    router.define(
      '/map',
      handler: _mapHandler,
    );
    router.define(
      '/busDetail/:routeId',
      handler: _busDetailHandler,
    );
    // Thêm các route mới
    router.define(
      '/findWay',
      handler: _mapScreenHandler,
    );
    router.define(
      '/listbus',
      handler: _listBusHandler,
    );
    router.define(
      '/welcome',
      handler: _welcomeHandler,
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
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  // Hiệu ứng trượt tùy chọn
  static Widget _customPageTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      bool slideFromRight) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: slideFromRight ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0), // Phải -> trái hoặc trái -> phải
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
