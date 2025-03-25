import 'package:flutter/foundation.dart';
import 'package:busmap/models/BusRoute/favorite_route.dart';
import 'package:busmap/models/favorite_stop.dart'; // Giả sử bạn có model FavoriteStop
import 'package:busmap/services/favorite_route_service.dart';
import 'package:busmap/services/favorite_stop_service.dart'; // Giả sử bạn có FavoriteStopService

class FavoriteProvider with ChangeNotifier {
  final FavoriteRouteService _favoriteRouteService = FavoriteRouteService();
  final FavoriteStopService _favoriteStopService = FavoriteStopService(); // Khởi tạo service cho trạm dừng
  List<FavoriteRoute> _favoriteRoutes = [];
  List<FavoriteStop> _favoriteStops = []; // Danh sách trạm dừng yêu thích
  bool _isLoadingRoutes = false;
  bool _isLoadingStops = false;
  String? _errorRoutes;
  String? _errorStops;

  List<FavoriteRoute> get favoriteRoutes => _favoriteRoutes;
  List<FavoriteStop> get favoriteStops => _favoriteStops;
  bool get isLoadingRoutes => _isLoadingRoutes;
  bool get isLoadingStops => _isLoadingStops;
  String? get errorRoutes => _errorRoutes;
  String? get errorStops => _errorStops;

  Future<void> fetchFavoriteRoutes(int userId) async {
    try {
      _isLoadingRoutes = true;
      _errorRoutes = null;
      notifyListeners();

      _favoriteRoutes = await _favoriteRouteService.getFavoriteRoutes(userId);
    } catch (e) {
      _errorRoutes = e.toString();
    } finally {
      _isLoadingRoutes = false;
      notifyListeners();
    }
  }

  Future<void> fetchFavoriteStops(int userId) async {
    try {
      _isLoadingStops = true;
      _errorStops = null;
      notifyListeners();

      _favoriteStops = await _favoriteStopService.getFavoriteStops(userId);
    } catch (e) {
      _errorStops = e.toString();
    } finally {
      _isLoadingStops = false;
      notifyListeners();
    }
  }

  Future<void> addFavoriteRoute(int userId, String routeNo, String routeName) async {
    try {
      await _favoriteRouteService.addFavoriteRoute(userId, routeNo, routeName);
      await fetchFavoriteRoutes(userId); // Làm mới danh sách tuyến
    } catch (e) {
      _errorRoutes = e.toString();
      notifyListeners();
    }
  }

  Future<void> addFavoriteStop(int userId, String stopId, String stopName) async {
    try {
      await _favoriteStopService.addFavoriteStop(userId, stopId, stopName);
      await fetchFavoriteStops(userId); // Làm mới danh sách trạm dừng
    } catch (e) {
      _errorStops = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteFavoriteRoute(int userId, String id) async {
    try {
      await _favoriteRouteService.deleteFavoriteRoute(userId, id);
      await fetchFavoriteRoutes(userId); // Làm mới danh sách tuyến
    } catch (e) {
      _errorRoutes = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteFavoriteStop(int userId, String id) async {
    try {
      await _favoriteStopService.deleteFavoriteStop(userId, id);
      await fetchFavoriteStops(userId); // Làm mới danh sách trạm dừng
    } catch (e) {
      _errorStops = e.toString();
      notifyListeners();
    }
  }
}