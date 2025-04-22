import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:busmap/screens/Dung/BusRouteMapPage.dart';// Updated import to reflect the renamed file

class BusRouteFinder extends StatefulWidget {
  final String? initialFrom;
  final String? initialTo;

  const BusRouteFinder({this.initialFrom, this.initialTo, super.key});

  @override
  _BusRouteFinderState createState() => _BusRouteFinderState();
}

class _BusRouteFinderState extends State<BusRouteFinder> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  List<Map<String, dynamic>> fromSuggestions = [];
  List<Map<String, dynamic>> toSuggestions = [];
  bool isFetchingRoutes = false;
  List<dynamic> busRoutes = [];
  Map<String, double>? fromCoords;
  Map<String, double>? toCoords;
  Timer? _debounce;


  @override
  void initState() {
    super.initState();
    // Gán giá trị initialFrom và initialTo vào các TextField
    if (widget.initialFrom != null) {
      _fromController.text = widget.initialFrom!;
    }
    if (widget.initialTo != null) {
      _toController.text = widget.initialTo!;
    }

    // Tự động tải danh sách nếu cả initialFrom và initialTo đều có giá trị
    if (widget.initialFrom != null && widget.initialTo != null) {
      // Lấy tọa độ từ initialFrom và initialTo
      Future.wait([
        getCoordinatesFromAddress(widget.initialFrom!).then((coords) {
          fromCoords = coords;
        }),
        getCoordinatesFromAddress(widget.initialTo!).then((coords) {
          toCoords = coords;
        }),
      ]).then((_) {
        // Sau khi lấy được tọa độ, gọi fetchBusRoutes
        if (fromCoords != null && toCoords != null) {
          fetchBusRoutes();
        }
      });
    }
  }


  @override
  void dispose() {
    _debounce?.cancel();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  Future<Map<String, double>?> getCoordinatesFromAddress(String address) async {
    const String apiKey = "pk.eyJ1IjoiZGF0MTUxMCIsImEiOiJjbTc4d3Rma3cwMTJyMnFvbGE4aGNsam5kIn0.2dAqovqd9va216DchFb4QQ"; // Thay bằng API Key của bạn
    final url = Uri.parse(
        "https://api.mapbox.com/geocoding/v5/mapbox.places/$address.json?access_token=$apiKey&country=VN&limit=1");

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

  Future<List<Map<String, dynamic>>> fetchAddressSuggestions(String query) async {
    if (query.isEmpty) return [];
    final url = Uri.parse("http://10.0.2.2:7222/api/Mapbox/autocomplete?query=$query");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      return [];
    }
  }

  Future<void> fetchBusRoutes() async {
    if (fromCoords == null) {
      fromCoords = await getCoordinatesFromAddress(_fromController.text);
    }
    if (toCoords == null) {
      toCoords = await getCoordinatesFromAddress(_toController.text);
    }

    if (fromCoords == null || toCoords == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không thể tìm thấy tọa độ cho địa chỉ đã nhập!")),
      );
      return;
    }

    setState(() {
      isFetchingRoutes = true;
      busRoutes.clear();
    });

    final url = Uri.parse(
        "http://apicms.ebms.vn/pathfinding/getpathbystop/${fromCoords!["latitude"]},${fromCoords!["longitude"]}/${toCoords!["latitude"]},${toCoords!["longitude"]}/2");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          busRoutes = data;
          isFetchingRoutes = false;
        });
      } else {
        throw Exception("Failed to load bus routes");
      }
    } catch (e) {
      setState(() {
        isFetchingRoutes = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi tìm tuyến xe buýt: $e")),
      );
    }
  }

  void _onFromChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (query.isEmpty) {
        setState(() {
          fromSuggestions.clear();
        });
        return;
      }
      final results = await fetchAddressSuggestions(query);
      setState(() {
        fromSuggestions = results;
      });
    });
  }

  void _onToChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (query.isEmpty) {
        setState(() {
          toSuggestions.clear();
        });
        return;
      }
      final results = await fetchAddressSuggestions(query);
      setState(() {
        toSuggestions = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bus Route Finder")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _fromController,
              decoration: const InputDecoration(labelText: "From"),
              onChanged: _onFromChanged,
              onSubmitted: (value) {
                setState(() {
                  fromSuggestions.clear(); // Ẩn gợi ý sau khi nhập xong
                });
              },
            ),
            _buildSuggestionsList(fromSuggestions, (suggestion) {
              setState(() {
                _fromController.text = suggestion["name"];
                fromCoords = {
                  "longitude": double.parse(suggestion["longitude"].toString()),
                  "latitude": double.parse(suggestion["latitude"].toString()),
                };
                fromSuggestions.clear(); // Ẩn gợi ý sau khi chọn
              });
            }),
            TextField(
              controller: _toController,
              decoration: const InputDecoration(labelText: "To"),
              onChanged: _onToChanged,
              onSubmitted: (value) {
                setState(() {
                  toSuggestions.clear(); // Ẩn gợi ý sau khi nhập xong
                });
              },
            ),
            _buildSuggestionsList(toSuggestions, (suggestion) {
              setState(() {
                _toController.text = suggestion["name"];
                toCoords = {
                  "longitude": double.parse(suggestion["longitude"].toString()),
                  "latitude": double.parse(suggestion["latitude"].toString()),
                };
                toSuggestions.clear(); // Ẩn gợi ý sau khi chọn
              });
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchBusRoutes,
              child: const Text("Find Bus Routes"),
            ),
            const SizedBox(height: 10),
            if (isFetchingRoutes) const CircularProgressIndicator(),
            Expanded(
              child: ListView.builder(
                itemCount: busRoutes.length,
                itemBuilder: (context, index) {
                  final route = busRoutes[index]; // Get the specific route data
                  return ListTile(
                    title: Text(route["Title"] ?? "Không có tiêu đề"),
                    subtitle: Text(route["Desc"] ?? "Không có mô tả"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BusRouteMapPage(routeData: route),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionsList(
      List<Map<String, dynamic>> suggestions, Function(Map<String, dynamic>) onSelect) {
    if (suggestions.isEmpty) return const SizedBox.shrink();
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(suggestions[index]["name"]),
            onTap: () => onSelect(suggestions[index]),
          );
        },
      ),
    );
  }
}