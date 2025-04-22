

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:busmap/service/api_service.dart';
import 'package:busmap/Router.dart';
import 'package:busmap/models/BusStopModel/BusStopModel.dart';
import 'dart:async';
import 'dart:math' as math;

class MapGpsSearch extends StatefulWidget {
  @override
  _MapGpsState createState() => _MapGpsState();
}

class _MapGpsState extends State<MapGpsSearch> {
  final MapController _mapController = MapController();
  LatLng _defaultLocation = LatLng(10.8411, 106.8097);
  LatLng? _currentPosition;
  double _currentZoom = 16.5;
  double _heading = 0.0; // Hướng xoay GPS
  List<Marker> _busStopMarkers = [];
  final ApiService _busStopService = ApiService();
  int _selectedIndex = 0;
  StreamSubscription<Position>? _positionStream; // Theo dõi GPS
  StreamSubscription<CompassEvent>? _compassStream; // Theo dõi la bàn

  @override
  void initState() {
    super.initState();
    _checkAndStartLocationTracking(); // Kiểm tra quyền và bắt đầu theo dõi
    _loadBusStops(); // Tải danh sách điểm dừng
    _listenCompass(); // Lắng nghe la bàn
  }

  /// Kiểm tra quyền và bắt đầu theo dõi vị trí
  Future<void> _checkAndStartLocationTracking() async {
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
        print("⚠️ Quyền vị trí bị từ chối!");
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      print("❌ Quyền vị trí bị chặn! Hãy bật quyền thủ công.");
      await Geolocator.openAppSettings();
      return;
    }

    // Lấy vị trí ban đầu
    await _getCurrentLocation();
    // Bắt đầu theo dõi liên tục
    _trackLocation();
  }

  /// Lấy vị trí hiện tại (một lần)
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print("📍 Vị trí hiện tại: ${position.latitude}, ${position.longitude}");
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _mapController.move(_currentPosition!, _currentZoom);
      });
    } catch (e) {
      print("Lỗi khi lấy vị trí: $e");
    }
  }

  /// Theo dõi vị trí liên tục
  void _trackLocation() {
    _positionStream?.cancel(); // Hủy stream cũ nếu có
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 2, // Cập nhật khi di chuyển 2m
      ),
    ).listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _heading = position.heading ?? _heading; // Dùng heading từ GPS nếu có
        _mapController.move(_currentPosition!, _currentZoom);
      });
    }, onError: (e) {
      print("Lỗi khi theo dõi vị trí: $e");
    });
  }

  /// Lắng nghe hướng xoay từ la bàn
  void _listenCompass() {
    _compassStream?.cancel(); // Hủy stream cũ nếu có
    _compassStream = FlutterCompass.events?.listen((CompassEvent event) {
      setState(() {
        _heading = event.heading ?? 0; // Dùng heading từ la bàn nếu GPS không có
      });
    }, onError: (e) {
      print("Lỗi khi theo dõi la bàn: $e");
    });
  }

  /// Tải danh sách điểm dừng xe buýt
  Future<void> _loadBusStops() async {
    try {
      List<BusStopModel> busStops = await _busStopService.fetchBusStops();
      setState(() {
        _busStopMarkers = busStops.map((busStop) => Marker(
          point: LatLng(busStop.latitude, busStop.longitude),
          width: 30.0,
          height: 20.0,
          child: const Icon(
            Icons.directions_bus,
            color: Colors.green,
            size: 27,
          ),
        )).toList();
      });
    } catch (e) {
      print("Lỗi tải điểm dừng: $e");
    }
  }

  /// Zoom In
  void _zoomIn() {
    setState(() {
      _currentZoom += 1;
      _mapController.move(_mapController.camera.center, _currentZoom);
    });
  }

  /// Zoom Out
  void _zoomOut() {
    setState(() {
      _currentZoom -= 1;
      _mapController.move(_mapController.camera.center, _currentZoom);
    });
  }

  /// Xử lý chọn BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      FluroRouterConfig.router.navigateTo(context, "/selectRouter");
    }
    if (index == 1) {
      FluroRouterConfig.router.navigateTo(context, "/findWay");
    }
  }

  @override
  void dispose() {
    _positionStream?.cancel(); // Hủy stream GPS
    _compassStream?.cancel(); // Hủy stream la bàn
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition ?? _defaultLocation,
              initialZoom: _currentZoom,
              onPositionChanged: (position, hasGesture) {
                setState(() {
                  _currentZoom = position.zoom ?? _currentZoom;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                'https://tile.thunderforest.com/transport/{z}/{x}/{y}.png?apikey=30bd60a20b974c7c8f4f269a3f66f902',
              ),
              if (_currentPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentPosition!,
                      width: 50.0,
                      height: 50.0,
                      child: Transform.rotate(
                        angle: _heading * (math.pi / 180),
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
                            Icon(
                              Icons.navigation,
                              color: Colors.white,
                              size: 25,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              if (_currentZoom >= 16.5) MarkerLayer(markers: _busStopMarkers),
            ],
          ),

          // Nút Back
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                FluroRouterConfig.router.navigateTo(context, '/homeMaster', replace: true); // Quay lại BusMapApp
              },
            ),
          ),

          // Các nút zoom và định vị
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "zoomIn",
                  onPressed: _zoomIn,
                  child: Icon(Icons.add),
                  mini: true,
                  backgroundColor: Colors.green,
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "zoomOut",
                  onPressed: _zoomOut,
                  child: Icon(Icons.remove),
                  mini: true,
                  backgroundColor: Colors.green,
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "myLocation",
                  onPressed: _getCurrentLocation,
                  child: Icon(Icons.my_location),
                  mini: true,
                  backgroundColor: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),

      // BottomNavigationBar bên ngoài Stack
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.green,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tra cứu'),
          BottomNavigationBarItem(icon: Icon(Icons.directions), label: 'Tìm đường'),
        ],
      ),
    );
  }

}