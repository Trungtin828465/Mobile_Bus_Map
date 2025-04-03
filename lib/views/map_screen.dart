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
      appBar: AppBar(title: Text("Mapbox Directions API")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: controller.startController,
                  onChanged: controller.updateStartSuggestions,
                  decoration: InputDecoration(labelText: "Địa chỉ bắt đầu"),
                  onTap: () => setState(() => controller.isStartFieldFocused = true),
                ),
                TextField(
                  controller: controller.endController,
                  onChanged: controller.updateEndSuggestions,
                  decoration: InputDecoration(labelText: "Địa chỉ kết thúc"),
                  onTap: () => setState(() => controller.isEndFieldFocused = true),
                ),
                ElevatedButton(
                  onPressed: controller.fetchRoute,
                  child: Text("Tìm đường"),
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
          Expanded(
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