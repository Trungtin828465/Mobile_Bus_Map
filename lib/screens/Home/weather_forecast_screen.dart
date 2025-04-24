import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '/providers/Khanh/weather_provider.dart';
import '/models/Khanh/weather_forecast.dart';

class WeatherForecastScreen extends StatefulWidget {
  const WeatherForecastScreen({super.key});

  @override
  _WeatherForecastScreenState createState() => _WeatherForecastScreenState();
}

class _WeatherForecastScreenState extends State<WeatherForecastScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
      weatherProvider.fetchWeatherForecast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dự Báo Thời Tiết - TP. Hồ Chí Minh'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          if (weatherProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (weatherProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lỗi: ${weatherProvider.error}',
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      weatherProvider.fetchWeatherForecast();
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          } else if (weatherProvider.weatherForecast == null) {
            return const Center(
              child: Text(
                'Không có dữ liệu thời tiết',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          final weather = weatherProvider.weatherForecast!;
          final forecastItems = weather.list;

          // Nhóm dữ liệu theo ngày sử dụng dt
          Map<String, List<ForecastItem>> groupedForecasts = {};
          for (var item in forecastItems) {
            final dateTime = DateTime.fromMillisecondsSinceEpoch(item.dt * 1000);
            final date = DateFormat('yyyy-MM-dd').format(dateTime);
            if (!groupedForecasts.containsKey(date)) {
              groupedForecasts[date] = [];
            }
            groupedForecasts[date]!.add(item);
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thời tiết hiện tại
                  Text(
                    'Thời tiết hiện tại tại ${weather.city.name}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // Card(
                  //   elevation: 4,
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(16.0),
                  //     child: Row(
                  //       children: [
                  //         Image.network(
                  //           'http://openweathermap.org/img/wn/${forecastItems[0].weather[0].icon}@2x.png',
                  //           width: 50,
                  //           height: 50,
                  //           errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                  //         ),
                  //         const SizedBox(width: 10),
                  //         Expanded(
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Text(
                  //                 'Nhiệt độ: ${forecastItems[0].main.temp?.toStringAsFixed(1) ?? 'N/A'}°C',
                  //                 style: const TextStyle(fontSize: 18),
                  //               ),
                  //               Text(
                  //                 'Mô tả: ${WeatherDescriptionTranslator.translateDescription(forecastItems[0].weather[0].description)}',
                  //                 style: const TextStyle(fontSize: 16),
                  //               ),
                  //               Text(
                  //                 'Độ ẩm: ${forecastItems[0].main.humidity?.toString() ?? 'N/A'}%',
                  //                 style: const TextStyle(fontSize: 16),
                  //               ),
                  //               Text(
                  //                 'Tốc độ gió: ${forecastItems[0].wind.speed?.toStringAsFixed(2) ?? 'N/A'} m/s',
                  //                 style: const TextStyle(fontSize: 16),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Builder(
                            builder: (context) {
                              final translatedDescription = WeatherDescriptionTranslator.translateDescription(
                                forecastItems[0].weather[0].description,
                              );

                              if (translatedDescription == 'Mây u ám') {
                                return Image.asset(
                                  'assets/img/may.png',
                                  width: 50,
                                  height: 50,
                                );
                              } else if (translatedDescription == 'Mây rải rác') {
                                return Image.asset(
                                  'assets/img/nangvua.png',
                                  width: 50,
                                  height: 50,
                                );
                              } else if (translatedDescription == 'Nắng vừa') {
                                return Image.asset(
                                  'assets/img/nang.png',
                                  width: 50,
                                  height: 50,
                                );
                              }
                              else if (translatedDescription == 'Mưa vừa') {
                                return Image.asset(
                                  'assets/img/mua.png',
                                  width: 50,
                                  height: 50,
                                );
                              } else {
                                return  Image.asset(
                                      'assets/img/samset.png', width: 50,
                                  height: 50,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nhiệt độ: ${forecastItems[0].main.temp?.toStringAsFixed(1) ?? 'N/A'}°C',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Text(
                                  'Mô tả: ${WeatherDescriptionTranslator.translateDescription(forecastItems[0].weather[0].description)}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Độ ẩm: ${forecastItems[0].main.humidity?.toString() ?? 'N/A'}%',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Tốc độ gió: ${forecastItems[0].wind.speed?.toStringAsFixed(2) ?? 'N/A'} m/s',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),


                  const SizedBox(height: 20),

                  // Dự báo 5 ngày
                  const Text(
                    'Dự báo 5 ngày tới',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  if (groupedForecasts.isEmpty)
                    const Center(
                      child: Text(
                        'Không có dữ liệu dự báo 5 ngày',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  else
                    ...groupedForecasts.entries.map((entry) {
                      final date = entry.key;
                      final items = entry.value;

                      final temps = items
                          .map((item) => item.main.temp)
                          .where((temp) => temp != null)
                          .cast<num>()
                          .toList();
                      final minTemps = items
                          .map((item) => item.main.tempMin != 0 ? item.main.tempMin : item.main.temp)
                          .where((temp) => temp != null && temp != 0)
                          .cast<num>()
                          .toList();
                      final maxTemps = items
                          .map((item) => item.main.tempMax != 0 ? item.main.tempMax : item.main.temp)
                          .where((temp) => temp != null && temp != 0)
                          .cast<num>()
                          .toList();

                      final sumTemps = temps.isNotEmpty ? temps.reduce((a, b) => a + b) : null;
                      final avgTemp = sumTemps != null && temps.isNotEmpty
                          ? sumTemps / temps.length
                          : null;
                      final minTemp = minTemps.isNotEmpty
                          ? minTemps.reduce((a, b) => a < b ? a : b)
                          : null;
                      final maxTemp = maxTemps.isNotEmpty
                          ? maxTemps.reduce((a, b) => a > b ? a : b)
                          : null;
                      final description = WeatherDescriptionTranslator.translateDescription(items[0].weather[0].description);

                      String formattedDate;
                      try {
                        formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(date));
                      } catch (e) {
                        formattedDate = 'N/A';
                      }

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text(
                            formattedDate,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nhiệt độ: ${minTemp?.toStringAsFixed(1) ?? 'N/A'}°C - ${maxTemp?.toStringAsFixed(1) ?? 'N/A'}°C',
                              ),
                              Text(
                                'Trung bình: ${avgTemp?.toStringAsFixed(1) ?? 'N/A'}°C',
                              ),
                              Text('Mô tả: $description'),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}