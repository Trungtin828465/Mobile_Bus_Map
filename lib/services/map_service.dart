import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../models/route_model.dart';

class MapService {
  //Lay ban do
  static Future<String> fetchTileUrl() async {
    final response = await http.get(Uri.parse("http://10.0.2.2:5204/api/Mapbox/tile-layer"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["tileUrl"];
    } else {
      print("Error fetching tile URL: ${response.statusCode}");
      return "";
    }
  }

  //Lay goi y
  //suggest: goi y
  static Future<List<String>> fetchAddressSuggestions(String query) async {
    if (query.isEmpty) return [];
    final url = Uri.parse("http://10.0.2.2:5204/api/Mapbox/autocomplete?query=$query");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data as List).map((place) => place["name"].toString()).toList();
    } else {
      return [];
    }
  }

  static Future<RouteModel?> fetchRoute(String start, String end) async {
    final startEncoded = Uri.encodeComponent(start);
    final endEncoded = Uri.encodeComponent(end);
    final url = "http://10.0.2.2:5204/api/Mapbox/route?start=$startEncoded&end=$endEncoded&profile=driving";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["routes"].isEmpty) return null;

      List coordinates = data["routes"][0]["geometry"]["coordinates"];
      if (coordinates.isEmpty) return null;

      List<LatLng> points = coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();

      return RouteModel(
        routePoints: points,
        startPoint: points.first,
        endPoint: points.last,
      );
    }
    return null;
  }
}