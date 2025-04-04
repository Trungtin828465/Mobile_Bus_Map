import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/address_suggestion_trip.dart';
import '../utils/constants.dart';

class MapboxService {
  Future<Map<String, double>?> getCoordinatesFromAddress(String address) async {
    final url = Uri.parse(
        "https://api.mapbox.com/geocoding/v5/mapbox.places/$address.json?access_token=${Constants.mapboxApiKey}&country=VN&limit=1");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["features"].isNotEmpty) {
        final coords = data["features"][0]["geometry"]["coordinates"];
        return {
          "longitude": coords[0],
          "latitude": coords[1],
        };
      }
    }
    return null;
  }

  Future<List<AddressSuggestion>> fetchAddressSuggestions(String query) async {
    if (query.isEmpty) return [];
    final url = Uri.parse("http://10.0.2.2:5204/api/Mapbox/autocomplete?query=$query");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data)
          .map((json) => AddressSuggestion.fromJson(json))
          .toList();
    } else {
      return [];
    }
  }
}