import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/busroute_model_trip.dart';

class BusRouteService {
  Future<List<BusRoute>> fetchBusRoutes(Map<String, double> fromCoords, Map<String, double> toCoords) async {
    final url = Uri.parse(
        "http://apicms.ebms.vn/pathfinding/getpathbystop/${fromCoords["latitude"]},${fromCoords["longitude"]}/${toCoords["latitude"]},${toCoords["longitude"]}/2");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data)
          .map((json) => BusRoute.fromJson(json))
          .toList();
    } else {
      throw Exception("Failed to load bus routes");
    }
  }
}