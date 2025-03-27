import 'package:flutter/material.dart';
import '../models/weather_forecast.dart';
import '../services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  WeatherForecast? _weatherForecast;
  bool _isLoading = false;
  String? _error;

  WeatherForecast? get weatherForecast => _weatherForecast;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final WeatherService _weatherService = WeatherService();

  Future<void> fetchWeatherForecast() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _weatherForecast = await _weatherService.fetchWeatherForecast();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}