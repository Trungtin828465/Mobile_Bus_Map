import 'dart:async';
import 'package:flutter/material.dart';
import '../services/mapbox_trip_service.dart';
import '../services/bus_route_trip_service.dart';
import '../models/address_suggestion_trip.dart';
import '../models/busroute_model_trip.dart';

class BusRouteController {
  final MapboxService _mapboxService = MapboxService();
  final BusRouteService _busRouteService = BusRouteService();
  List<AddressSuggestion> fromSuggestions = [];
  List<AddressSuggestion> toSuggestions = [];
  bool isFetchingRoutes = false;
  List<BusRoute> busRoutes = [];
  Map<String, double>? fromCoords;
  Map<String, double>? toCoords;
  Timer? _debounce;
  bool get hasFromSuggestions => fromSuggestions.isNotEmpty;
  bool get hasToSuggestions => toSuggestions.isNotEmpty;

  void dispose() {
    _debounce?.cancel();
  }

  void onFromChanged(String query, Function setState) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 300), () async {
      if (query.isEmpty) {
        setState(() {
          fromSuggestions.clear();
        });
        return;
      }
      final results = await _mapboxService.fetchAddressSuggestions(query);
      setState(() {
        fromSuggestions = results;
      });
    });
  }

  void onToChanged(String query, Function setState) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 300), () async {
      if (query.isEmpty) {
        setState(() {
          toSuggestions.clear();
        });
        return;
      }
      final results = await _mapboxService.fetchAddressSuggestions(query);
      setState(() {
        toSuggestions = results;
      });
    });
  }

  void clearFromSuggestions() {
    fromSuggestions.clear();
  }

  void clearToSuggestions() {
    toSuggestions.clear();
  }

  void setFromCoords(AddressSuggestion suggestion) {
    fromCoords = {
      "longitude": suggestion.longitude,
      "latitude": suggestion.latitude,
    };
  }

  void setToCoords(AddressSuggestion suggestion) {
    toCoords = {
      "longitude": suggestion.longitude,
      "latitude": suggestion.latitude,
    };
  }


  void selectFromSuggestion(suggestion, Function setState, TextEditingController controller) {
    setState(() {
      controller.text = suggestion.name;
      setFromCoords(suggestion);
      clearFromSuggestions();
    });
  }

  void selectToSuggestion(suggestion, Function setState, TextEditingController controller) {
    setState(() {
      controller.text = suggestion.name;
      setToCoords(suggestion);
      clearToSuggestions();
    });
  }





  Future<void> fetchBusRoutes(
      BuildContext context, String fromAddress, String toAddress, Function setState) async {
    if (fromCoords == null) {
      fromCoords = await _mapboxService.getCoordinatesFromAddress(fromAddress);
    }
    if (toCoords == null) {
      toCoords = await _mapboxService.getCoordinatesFromAddress(toAddress);
    }

    if (fromCoords == null || toCoords == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Không thể tìm thấy tọa độ cho địa chỉ đã nhập!")),
      );
      return;
    }

    setState(() {
      isFetchingRoutes = true;
      busRoutes.clear();
    });

    try {
      final routes = await _busRouteService.fetchBusRoutes(fromCoords!, toCoords!);
      setState(() {
        busRoutes = routes;
        isFetchingRoutes = false;
      });
    } catch (e) {
      setState(() {
        isFetchingRoutes = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi tìm tuyến xe buýt: $e")),
      );
    }
  }
}