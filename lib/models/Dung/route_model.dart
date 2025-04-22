import 'package:latlong2/latlong.dart';

class RouteModel {
  final List<LatLng> routePoints;
  final LatLng? startPoint;
  final LatLng? endPoint;

  RouteModel({
    required this.routePoints,
    this.startPoint,
    this.endPoint,
  });
}