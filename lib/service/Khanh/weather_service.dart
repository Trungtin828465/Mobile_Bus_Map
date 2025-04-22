import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:busmap/models/Khanh/weather_forecast.dart';


class WeatherService {
  final String _baseUrl;
  WeatherService() : _baseUrl = _determineBaseUrl();

  static String _determineBaseUrl() {
    const androidEmulatorBaseUrl = "https://10.0.2.2:7222/api/weather/forecast";
    const iosSimulatorBaseUrl = "https://localhost:7222/api/weather/forecast";
    const physicalDeviceBaseUrl = "https://192.168.1.x:7222/api/weather/forecast";

    return androidEmulatorBaseUrl;
  }
  Future<WeatherForecast> fetchWeatherForecast() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      return WeatherForecast.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Không thể lấy dữ liệu thời tiết: ${response.statusCode}');
    }
  }
}