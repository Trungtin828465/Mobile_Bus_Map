import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/map_controller.dart';
import 'widgets/suggestion_list.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapControllerLogic controller;

  @override
  void initState() {
    super.initState();
    controller = MapControllerLogic(
      onStartSuggestionsUpdated: (suggestions) {
        setState(() {
          controller.startSuggestions = suggestions;
        });
      },
      onEndSuggestionsUpdated: (suggestions) {
        setState(() {
          controller.endSuggestions = suggestions;
        });
      },
      onRouteUpdated: (routePoints, startPoint, endPoint) {
        setState(() {
          controller.routePoints = routePoints;
          controller.startPoint = startPoint;
          controller.endPoint = endPoint;
          controller.startSuggestions = [];
          controller.endSuggestions = [];
        });
        controller.mapController.move(routePoints.first, 14.0);
      },
      onTileUrlUpdated: (tileUrl) {
        setState(() {
          controller.tileUrl = tileUrl;
        });
      },
    );
    controller.fetchTileUrl();
    controller.startController.addListener(controller.onTextChanged);
    controller.endController.addListener(controller.onTextChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: controller.tileUrl.isEmpty
                ? Center(child: CircularProgressIndicator())
                : FlutterMap(
              mapController: controller.mapController,
              options: MapOptions(
                initialCenter: LatLng(10.762622, 106.660172),
                initialZoom: 12,
              ),
              children: [
                TileLayer(
                  urlTemplate: controller.tileUrl,
                  userAgentPackageName: 'com.example.app',
                ),
                if (controller.routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: controller.routePoints,
                        strokeWidth: 4.0,
                        color: Colors.red,
                      ),
                    ],
                  ),
                if (controller.startPoint != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: controller.startPoint!,
                        width: 40,
                        height: 40,
                        child: Icon(Icons.location_on, color: Colors.green, size: 40),
                      ),
                    ],
                  ),
                if (controller.endPoint != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: controller.endPoint!,
                        width: 40,
                        height: 40,
                        child: Icon(Icons.flag, color: Colors.red, size: 40),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,

            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 50),
                      TextField(
                        controller: controller.startController,
                        onChanged: controller.updateStartSuggestions,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.place, color: Colors.red),
                          hintText: "Nhập địa điểm đi",
                          filled: true,
                          fillColor: Colors.green.shade700,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        onTap: () => setState(() => controller.isStartFieldFocused = true),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: controller.endController,
                        onChanged: controller.updateEndSuggestions,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.place, color: Colors.black),
                          hintText: "Nhập địa điểm đến",
                          filled: true,
                          fillColor: Colors.green.shade700,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        onTap: () => setState(() => controller.isEndFieldFocused = true),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: controller.fetchRoute,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: Size(double.infinity, 40),
                        ),
                        child: Text("Tìm Đường", style: TextStyle(color: Colors.green, fontSize: 17)),
                      ),
                    ],
                  ),
                ),
                if (controller.isStartFieldFocused && controller.startSuggestions.isNotEmpty)
                  SuggestionList(
                    suggestions: controller.startSuggestions,
                    controller: controller.startController,
                    onSelected: () {
                      setState(() => controller.isStartFieldFocused = false);
                      controller.onTextChanged();
                    },
                  ),
                if (controller.isEndFieldFocused && controller.endSuggestions.isNotEmpty)
                  SuggestionList(
                    suggestions: controller.endSuggestions,
                    controller: controller.endController,
                    onSelected: () {
                      setState(() => controller.isEndFieldFocused = false);
                      controller.onTextChanged();
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
