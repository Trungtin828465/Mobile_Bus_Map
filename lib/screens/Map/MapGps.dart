import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_compass/flutter_compass.dart';
import 'package:busmap/service/Dung/map_service.dart';
import 'package:busmap/controllers/map_controller.dart';
import 'dart:convert';
class MapGps extends StatefulWidget {
  @override
  _MapGpsState createState() => _MapGpsState();
}

class _MapGpsState extends State<MapGps> {
  final MapController _mapController = MapController();
  LatLng _defaultLocation = LatLng(10.8411, 106.8097); // Mặc định: Lê Văn Việt
  LatLng? _currentPosition;
  double _currentZoom = 14.0;
  double _heading = 0.0; // Hướng di chuyển
  StreamSubscription<Position>? _positionStream;
  StreamSubscription<CompassEvent>? _compassStream;
 late MapControllerLogic controller;
  String? _tileUrl;

  @override
  void initState() {
    super.initState();
    _checkAndRequestLocationPermission();
    _trackLocation();
    _trackCompass();
    // Gọi sau khi widget được render xong
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchTileUrl();
    });
  }

  Future<void> fetchTileUrl() async {
    try {
      final response = await http.get(Uri.parse("https://10.0.2.2:7222/api/Mapbox/tile-layer"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _tileUrl = data["tileUrl"];
        });
      } else {
        print("Lỗi khi gọi API: ${response.statusCode}");
      }
    } catch (e) {
      print("Lỗi khi fetch tileUrl: $e");
    }
  }

  /// Kiểm tra và yêu cầu quyền vị trí
  Future<void> _checkAndRequestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng bật dịch vụ định vị!")),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Quyền vị trí bị từ chối!")),
        );
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
            "Quyền vị trí bị từ chối vĩnh viễn! Vào cài đặt để bật.")),
      );
      await Geolocator.openAppSettings();
      return;
    }
  }

  /// Theo dõi vị trí liên tục
  void _trackLocation() {
    _positionStream?.cancel(); // Hủy stream cũ nếu có
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1, // số càng nhỏ càng mượt
      ),
    ).listen((Position position) {
      _updateLocation(position.latitude, position.longitude, position.heading);
    }, onError: (e) {
      print("Lỗi khi theo dõi vị trí: $e");
    });
  }

  /// Theo dõi hướng xoay của thiết bị
  void _trackCompass() {
    _compassStream?.cancel(); // Hủy stream cũ nếu có
    _compassStream = FlutterCompass.events?.listen((CompassEvent event) {
      setState(() {
        _heading = event.heading ?? 0.0;
      });
    }, onError: (e) {
      print("Lỗi khi theo dõi la bàn: $e");
    });
  }

  /// Cập nhật vị trí và di chuyển bản đồ
  void _updateLocation(double lat, double lng, double? heading) {
    setState(() {
      _currentPosition = LatLng(lat, lng);
      _heading = heading ?? _heading;
      _mapController.move(_currentPosition!, _currentZoom);
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _compassStream?.cancel();
    super.dispose();
  }

  void _zoomIn() {
    setState(() {
      _currentZoom += 1;
      _mapController.move(_mapController.camera.center, _currentZoom);
    });
  }

  void _zoomOut() {
    setState(() {
      _currentZoom -= 1;
      _mapController.move(_mapController.camera.center, _currentZoom);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _currentPosition ?? _defaultLocation,
            initialZoom: _currentZoom,
          ),
          children: [
            if (_tileUrl != null)
              TileLayer(
                urlTemplate: _tileUrl!,
                userAgentPackageName: 'com.example.app',
              ),
            if (_currentPosition != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentPosition!,
                    width: 50.0,
                    height: 50.0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue.withOpacity(0.3),
                          ),
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue.withOpacity(0.6),
                          ),
                        ),
                        Transform.rotate(
                          angle: _heading * (math.pi / 180),
                          child: const Icon(
                            Icons.navigation,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: Column(
            children: [
              FloatingActionButton(
                heroTag: "zoomIn",
                onPressed: _zoomIn,
                child: const Icon(Icons.add),
                mini: true,
                backgroundColor: Colors.green,
              ),
              const SizedBox(height: 10),
              FloatingActionButton(
                heroTag: "zoomOut",
                onPressed: _zoomOut,
                child: const Icon(Icons.remove),
                mini: true,
                backgroundColor: Colors.green,
              ),
              const SizedBox(height: 10),
              FloatingActionButton(
                heroTag: "myLocation",
                onPressed: () async {
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high,
                    );
                    _updateLocation(position.latitude, position.longitude,
                        position.heading);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Không thể lấy vị trí: $e")),
                    );
                  }
                },
                child: const Icon(Icons.my_location),
                mini: true,
                backgroundColor: Colors.blue,
              ),
            ],
          ),
        ),
      ],
    );

  }
}