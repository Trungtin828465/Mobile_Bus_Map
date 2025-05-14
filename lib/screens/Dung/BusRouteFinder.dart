import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import  'package:busmap/screens/Dung/BusRouteMapPage.dart';

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
    if (widget.initialFrom != null) {
      _fromController.text = widget.initialFrom!;
    }
    if (widget.initialTo != null) {
      _toController.text = widget.initialTo!;
    }

    if (widget.initialFrom != null && widget.initialTo != null) {
      Future.wait([
        getCoordinatesFromAddress(widget.initialFrom!).then((coords) {
          fromCoords = coords;
        }),
        getCoordinatesFromAddress(widget.initialTo!).then((coords) {
          toCoords = coords;
        }),
      ]).then((_) {
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

  Future<void> saveTravelInfo(TravelInfo travelInfo) async {
    final url = Uri.parse('https://10.0.2.2:7222/api/TravelInfo');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(travelInfo.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Lưu thành công!');
      } else {
        print('Lỗi: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to save TravelInfo: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving TravelInfo: $e');
      throw Exception('Error saving TravelInfo: $e');
    }
  }

  Future<Map<String, double>?> getCoordinatesFromAddress(String address) async {
    const String apiKey = "pk.eyJ1IjoiZGF0MTUxMCIsImEiOiJjbTc4d3Rma3cwMTJyMnFvbGE4aGNsam5kIn0.2dAqovqd9va216DchFb4QQ";
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
    final url = Uri.parse("https://10.0.2.2:7222/api/Mapbox/autocomplete?query=$query");
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
      appBar: AppBar(
        title: const Text(
          "Bus Route Finder",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _fromController,
                decoration: InputDecoration(
                  labelText: "From",
                  labelStyle: const TextStyle(color: Colors.green),
                  prefixIcon: const Icon(Icons.location_on, color: Colors.green),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.green, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.green.shade50,
                ),
                onChanged: _onFromChanged,
                onFieldSubmitted: (value) {
                  setState(() {
                    fromSuggestions.clear();
                  });
                },
              ),
              const SizedBox(height: 8),
              _buildSuggestionsList(fromSuggestions, (suggestion) {
                setState(() {
                  _fromController.text = suggestion["name"];
                  fromCoords = {
                    "longitude": double.parse(suggestion["longitude"].toString()),
                    "latitude": double.parse(suggestion["latitude"].toString()),
                  };
                  fromSuggestions.clear();
                });
              }),
              const SizedBox(height: 16),
              TextFormField(
                controller: _toController,
                decoration: InputDecoration(
                  labelText: "To",
                  labelStyle: const TextStyle(color: Colors.green),
                  prefixIcon: const Icon(Icons.flag, color: Colors.green),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.green, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.green.shade50,
                ),
                onChanged: _onToChanged,
                onFieldSubmitted: (value) {
                  setState(() {
                    toSuggestions.clear();
                  });
                },
              ),
              const SizedBox(height: 8),
              _buildSuggestionsList(toSuggestions, (suggestion) {
                setState() {
                  _toController.text = suggestion["name"];
                  toCoords = {
                    "longitude": double.parse(suggestion["longitude"].toString()),
                    "latitude": double.parse(suggestion["latitude"].toString()),
                  };
                  toSuggestions.clear();
                }
              }),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: fetchBusRoutes,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Find Bus Routes",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (isFetchingRoutes)
                const Center(child: CircularProgressIndicator(color: Colors.green)),
              Expanded(
                child: busRoutes.isEmpty && !isFetchingRoutes
                    ? const Center(
                  child: Text(
                    "No routes found. Try different locations.",
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                )
                    : ListView.builder(
                  itemCount: busRoutes.length,
                  itemBuilder: (context, index) {
                    final route = busRoutes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Row(
                          children: [
                            const Icon(
                              Icons.directions_bus,
                              color: Colors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                route["Title"] ?? "Không có tiêu đề",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  route["Desc"] ?? "Không có mô tả",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.green,
                        ),
                        onTap: () async {
                          try {
                            if (_fromController.text.isEmpty || _toController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please enter both from and to locations')),
                              );
                              return;
                            }

                            // Uncomment if you want to save TravelInfo
                            // final info = TravelInfo(
                            //   fromLocation: _fromController.text,
                            //   toLocation: _toController.text,
                            //   travelDateTime: DateTime.now(),
                            //   userId: 1,
                            // );
                            // await saveTravelInfo(info);

                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BusRouteMapPage(
                                    routeData: busRoutes[index],
                                    fromLocation: _fromController.text,
                                    toLocation: _toController.text,
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionsList(
      List<Map<String, dynamic>> suggestions, Function(Map<String, dynamic>) onSelect) {
    if (suggestions.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(top: 8),
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              suggestions[index]["name"],
              style: const TextStyle(fontSize: 14),
            ),
            onTap: () => onSelect(suggestions[index]),
          );
        },
      ),
    );
  }
}

class TravelInfo {
  final String fromLocation;
  final String toLocation;
  final DateTime travelDateTime;
  final int userId;

  TravelInfo({
    required this.fromLocation,
    required this.toLocation,
    required this.travelDateTime,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'FromLocation': fromLocation,
      'ToLocation': toLocation,
      'TravelDateTime': travelDateTime.toIso8601String(),
      'UserId': userId,
    };
  }
}