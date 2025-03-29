import 'dart:convert';

class WeatherForecast {
  final City city;
  final List<ForecastItem> list;

  WeatherForecast({
    required this.city,
    required this.list,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      city: City.fromJson(json['city']),
      list: (json['list'] as List)
          .map((item) => ForecastItem.fromJson(item))
          .toList(),
    );
  }
}

class City {
  final String name;

  City({required this.name});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'] ?? 'Unknown',
    );
  }
}

class ForecastItem {
  final int dt; // Thêm trường dt
  final String? dtTxt; // dtTxt có thể là null
  final Main main;
  final List<Weather> weather;
  final Wind wind;

  ForecastItem({
    required this.dt,
    this.dtTxt,
    required this.main,
    required this.weather,
    required this.wind,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    return ForecastItem(
      dt: json['dt'] ?? 0, // Thêm dt
      dtTxt: json['dt_txt'], // dtTxt có thể là null
      main: Main.fromJson(json['main']),
      weather: (json['weather'] as List)
          .map((item) => Weather.fromJson(item))
          .toList(),
      wind: Wind.fromJson(json['wind']),
    );
  }
}

class Main {
  final num? temp;
  final num? tempMin;
  final num? tempMax;
  final num? humidity;

  Main({
    this.temp,
    this.tempMin,
    this.tempMax,
    this.humidity,
  });

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
      temp: json['temp'] as num?,
      tempMin: json['temp_min'] as num?,
      tempMax: json['temp_max'] as num?,
      humidity: json['humidity'] as num?,
    );
  }
}

class Weather {
  final String description;
  final String icon;

  Weather({
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      description: json['description'] ?? 'Unknown',
      icon: json['icon'] ?? '',
    );
  }
}

class Wind {
  final num? speed;

  Wind({this.speed});

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: json['speed'] as num?,
    );
  }
}

class WeatherDescriptionTranslator {
  static const Map<String, String> descriptionMap = {
    'clear sky': 'Trời quang đãng',
    'few clouds': 'Mây thưa',
    'scattered clouds': 'Mây rải rác',
    'broken clouds': 'Mây rách',
    'overcast clouds': 'Mây u ám',
    'light rain': 'Mưa nhẹ',
    'moderate rain': 'Mưa vừa',
    'heavy intensity rain': 'Mưa lớn',
    'very heavy rain': 'Mưa rất lớn',
    'extreme rain': 'Mưa cực lớn',
    'light intensity shower rain': 'Mưa rào nhẹ',
    'shower rain': 'Mưa rào',
    'heavy intensity shower rain': 'Mưa rào lớn',
    'thunderstorm': 'Giông bão',
    'thunderstorm with light rain': 'Giông bão kèm mưa nhẹ',
    'thunderstorm with rain': 'Giông bão kèm mưa',
    'light snow': 'Tuyết nhẹ',
    'snow': 'Tuyết',
    'heavy snow': 'Tuyết lớn',
    'mist': 'Sương mù',
    'fog': 'Sương mù dày',
    'haze': 'Sương mù nhẹ',
  };

  static String translateDescription(String description) {
    return descriptionMap[description.toLowerCase()] ?? description;
  }
}