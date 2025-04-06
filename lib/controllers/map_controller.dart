import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/map_service.dart';
import 'package:utilitybus/routes/route_app.dart';

class MapControllerLogic {
  String tileUrl = "";
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  List<LatLng> routePoints = [];
  LatLng? startPoint;
  LatLng? endPoint;
  List<String> startSuggestions = [];
  List<String> endSuggestions = [];
  MapController mapController = MapController();
  Timer? _debounce;
  bool isStartFieldFocused = false;
  bool isEndFieldFocused = false;

  // final BusRouteController _controller = BusRouteController();
  //Tao callback functions
  final Function(List<String>) onStartSuggestionsUpdated;
  final Function(List<String>) onEndSuggestionsUpdated;
  final Function(List<LatLng>, LatLng?, LatLng?) onRouteUpdated;
  final Function(String) onTileUrlUpdated;

  MapControllerLogic({
    required this.onStartSuggestionsUpdated,
    required this.onEndSuggestionsUpdated,
    required this.onRouteUpdated,
    required this.onTileUrlUpdated,
  });

  Future<void> fetchTileUrl() async {
    final tileUrl = await MapService.fetchTileUrl();
    onTileUrlUpdated(tileUrl);
  }

  void updateStartSuggestions(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      List<String> results = await MapService.fetchAddressSuggestions(query);
      onStartSuggestionsUpdated(results);
    });
  }

  void updateEndSuggestions(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      List<String> results = await MapService.fetchAddressSuggestions(query);
      onEndSuggestionsUpdated(results);
    });
  }

  Future<void> fetchRoute() async {
    if (startController.text.isEmpty || endController.text.isEmpty) return;

    final routeData = await MapService.fetchRoute(startController.text, endController.text);
    if (routeData != null) {
      onRouteUpdated(routeData.routePoints, routeData.startPoint, routeData.endPoint);
    }
  }

  void onTextChanged() {
    if (startController.text.isNotEmpty && endController.text.isNotEmpty) {
      fetchRoute();
    }
  }

  Future<void> onTriplist(BuildContext context) async {
    if (startController.text.isNotEmpty && endController.text.isNotEmpty) {
      final routeData = await MapService.fetchRoute(startController.text, endController.text);

      if (routeData != null) {
        // Chờ 1 chút để API fetch xong
        await Future.delayed(Duration(milliseconds: 500));

        // Điều hướng đến danh sách tuyến
        FluroRouterConfig.navigateToPage(
          context,
           "/listbus?start=${Uri.encodeComponent(startController.text)}&end=${Uri.encodeComponent(endController.text)}",

        );
      } else {
        // showSnackBar(context, "Vui lòng nhập đúng địa chỉ.");
      }
    } else {
      // showSnackBar(context, "Vui lòng nhập địa chỉ bắt đầu và điểm đến.");
    }
  }



  void dispose() {
    _debounce?.cancel();
    startController.dispose();
    endController.dispose();
  }
}