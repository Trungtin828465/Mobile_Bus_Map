// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:busmap/screens/Dung/BusRouteMapPage.dart';// Updated import to reflect the renamed file
//
// class BusRouteFinder extends StatefulWidget {
//   final String? initialFrom;
//   final String? initialTo;
//
//   const BusRouteFinder({this.initialFrom, this.initialTo, super.key});
//
//   @override
//   _BusRouteFinderState createState() => _BusRouteFinderState();
// }
//
// class _BusRouteFinderState extends State<BusRouteFinder> {
//   final TextEditingController _fromController = TextEditingController();
//   final TextEditingController _toController = TextEditingController();
//   List<Map<String, dynamic>> fromSuggestions = [];
//   List<Map<String, dynamic>> toSuggestions = [];
//   bool isFetchingRoutes = false;
//   List<dynamic> busRoutes = [];
//   Map<String, double>? fromCoords;
//   Map<String, double>? toCoords;
//   Timer? _debounce;
//
//
//   @override
//   void initState() {
//     super.initState();
//     // Gán giá trị initialFrom và initialTo vào các TextField
//     if (widget.initialFrom != null) {
//       _fromController.text = widget.initialFrom!;
//     }
//     if (widget.initialTo != null) {
//       _toController.text = widget.initialTo!;
//     }
//
//     // Tự động tải danh sách nếu cả initialFrom và initialTo đều có giá trị
//     if (widget.initialFrom != null && widget.initialTo != null) {
//       // Lấy tọa độ từ initialFrom và initialTo
//       Future.wait([
//         getCoordinatesFromAddress(widget.initialFrom!).then((coords) {
//           fromCoords = coords;
//         }),
//         getCoordinatesFromAddress(widget.initialTo!).then((coords) {
//           toCoords = coords;
//         }),
//       ]).then((_) {
//         // Sau khi lấy được tọa độ, gọi fetchBusRoutes
//         if (fromCoords != null && toCoords != null) {
//           fetchBusRoutes();
//         }
//       });
//     }
//   }
//
//
//   @override
//   void dispose() {
//     _debounce?.cancel();
//     _fromController.dispose();
//     _toController.dispose();
//     super.dispose();
//   }
//
//
// // Lưu thông tin
//   Future<void> saveTravelInfo(TravelInfo travelInfo) async {
//     // // Replace '8080' with the actual port your backend server is running on
//     // final url = Uri.parse('http://10.0.2.2:5204/api/TravelInfo'); // For Android emulator
//     // // If testing on a real device, use your computer's IP, e.g., 'http://192.168.1.x:8080/api/TravelInfo'
//     //
//     // try {
//     //   final response = await http.post(
//     //     url,
//     //     headers: {'Content-Type': 'application/json'},
//     //     body: jsonEncode(travelInfo.toJson()),
//     //   );
//     //
//     //   if (response.statusCode == 200 || response.statusCode == 201) {
//     //     print('Lưu thành công!');
//     //   } else {
//     //     print('Lỗi: ${response.statusCode}');
//     //     print('Response body: ${response.body}');
//     //     throw Exception('Failed to save TravelInfo: ${response.statusCode}');
//     //   }
//     // } catch (e) {
//     //   print('Error saving TravelInfo: $e');
//     //   throw Exception('Error saving TravelInfo: $e');
//     // }
//   }
//   Future<Map<String, double>?> getCoordinatesFromAddress(String address) async {
//     const String apiKey = "pk.eyJ1IjoiZGF0MTUxMCIsImEiOiJjbTc4d3Rma3cwMTJyMnFvbGE4aGNsam5kIn0.2dAqovqd9va216DchFb4QQ"; // Thay bằng API Key của bạn
//     final url = Uri.parse(
//         "https://api.mapbox.com/geocoding/v5/mapbox.places/$address.json?access_token=$apiKey&country=VN&limit=1");
//
//     final response = await http.get(url);
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data["features"].isNotEmpty) {
//         final coords = data["features"][0]["geometry"]["coordinates"];
//         return {
//           "longitude": coords[0],
//           "latitude": coords[1],
//         };
//       }
//     }
//     return null;
//   }
//
//   Future<List<Map<String, dynamic>>> fetchAddressSuggestions(String query) async {
//     if (query.isEmpty) return [];
//     final url = Uri.parse("https://10.0.2.2:7222/api/Mapbox/autocomplete?query=$query");
//     final response = await http.get(url);
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       return List<Map<String, dynamic>>.from(data);
//     } else {
//       return [];
//     }
//   }
//
//   Future<void> fetchBusRoutes() async {
//     if (fromCoords == null) {
//       fromCoords = await getCoordinatesFromAddress(_fromController.text);
//     }
//     if (toCoords == null) {
//       toCoords = await getCoordinatesFromAddress(_toController.text);
//     }
//
//     if (fromCoords == null || toCoords == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Không thể tìm thấy tọa độ cho địa chỉ đã nhập!")),
//       );
//       return;
//     }
//
//     setState(() {
//       isFetchingRoutes = true;
//       busRoutes.clear();
//     });
//
//     final url = Uri.parse(
//         "http://apicms.ebms.vn/pathfinding/getpathbystop/${fromCoords!["latitude"]},${fromCoords!["longitude"]}/${toCoords!["latitude"]},${toCoords!["longitude"]}/2");
//
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           busRoutes = data;
//           isFetchingRoutes = false;
//         });
//       } else {
//         throw Exception("Failed to load bus routes");
//       }
//     } catch (e) {
//       setState(() {
//         isFetchingRoutes = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Lỗi khi tìm tuyến xe buýt: $e")),
//       );
//     }
//   }
//
//   void _onFromChanged(String query) {
//     if (_debounce?.isActive ?? false) _debounce?.cancel();
//     _debounce = Timer(const Duration(milliseconds: 300), () async {
//       if (query.isEmpty) {
//         setState(() {
//           fromSuggestions.clear();
//         });
//         return;
//       }
//       final results = await fetchAddressSuggestions(query);
//       setState(() {
//         fromSuggestions = results;
//       });
//     });
//   }
//
//   void _onToChanged(String query) {
//     if (_debounce?.isActive ?? false) _debounce?.cancel();
//     _debounce = Timer(const Duration(milliseconds: 300), () async {
//       if (query.isEmpty) {
//         setState(() {
//           toSuggestions.clear();
//         });
//         return;
//       }
//       final results = await fetchAddressSuggestions(query);
//       setState(() {
//         toSuggestions = results;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Bus Route Finder")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _fromController,
//               decoration: const InputDecoration(labelText: "From"),
//               onChanged: _onFromChanged,
//               onSubmitted: (value) {
//                 setState(() {
//                   fromSuggestions.clear(); // Ẩn gợi ý sau khi nhập xong
//                 });
//               },
//             ),
//             _buildSuggestionsList(fromSuggestions, (suggestion) {
//               setState(() {
//                 _fromController.text = suggestion["name"];
//                 fromCoords = {
//                   "longitude": double.parse(suggestion["longitude"].toString()),
//                   "latitude": double.parse(suggestion["latitude"].toString()),
//                 };
//                 fromSuggestions.clear(); // Ẩn gợi ý sau khi chọn
//               });
//             }),
//             TextField(
//               controller: _toController,
//               decoration: const InputDecoration(labelText: "To"),
//               onChanged: _onToChanged,
//               onSubmitted: (value) {
//                 setState(() {
//                   toSuggestions.clear(); // Ẩn gợi ý sau khi nhập xong
//                 });
//               },
//             ),
//             _buildSuggestionsList(toSuggestions, (suggestion) {
//               setState(() {
//                 _toController.text = suggestion["name"];
//                 toCoords = {
//                   "longitude": double.parse(suggestion["longitude"].toString()),
//                   "latitude": double.parse(suggestion["latitude"].toString()),
//                 };
//                 toSuggestions.clear(); // Ẩn gợi ý sau khi chọn
//               });
//             }),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: fetchBusRoutes,
//               child: const Text("Find Bus Routes"),
//
//             ),
//             const SizedBox(height: 10),
//             if (isFetchingRoutes) const CircularProgressIndicator(),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: busRoutes.length,
//                 itemBuilder: (context, index) {
//                   final route = busRoutes[index]; // Get the specific route data
//                   return ListTile(
//                     title: Text(route["Title"] ?? "Không có tiêu đề"),
//                     subtitle: Text(route["Desc"] ?? "Không có mô tả"),
//                     onTap: () async {
//                       try {
//                         if (_fromController.text.isEmpty || _toController.text.isEmpty) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text('Please enter both from and to locations')),
//                           );
//                           return;
//                         }
//
//                         if (context.mounted) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => BusRouteMapPage(
//                                 routeData: busRoutes[index],
//                                 fromLocation: _fromController.text,
//                                 toLocation: _toController.text,
//                               ),
//                             ),
//                           );
//
//                         }
//                       } catch (e) {
//                         if (context.mounted) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text('Error: $e')),
//                           );
//                         }
//                       }
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSuggestionsList(
//       List<Map<String, dynamic>> suggestions, Function(Map<String, dynamic>) onSelect) {
//     if (suggestions.isEmpty) return const SizedBox.shrink();
//     return Container(
//       height: 200,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: Colors.grey),
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: ListView.builder(
//         itemCount: suggestions.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(suggestions[index]["name"]),
//             onTap: () => onSelect(suggestions[index]),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class TravelInfo {
//   final String fromLocation;
//   final String toLocation;
//   final DateTime travelDateTime;
//   final int userId;
//
//   TravelInfo({
//     required this.fromLocation,
//     required this.toLocation,
//     required this.travelDateTime,
//     required this.userId,
//   });
//
//   // Add toJson method to serialize the object to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'fromLocation': fromLocation,
//       'toLocation': toLocation,
//       'travelDateTime': travelDateTime.toIso8601String(),
//       'userId': userId,
//     };
//   }
// }


import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:busmap/screens/Dung/BusRouteMapPage.dart';

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
    if (widget.initialFrom != null) _fromController.text = widget.initialFrom!;
    if (widget.initialTo != null) _toController.text = widget.initialTo!;
    if (widget.initialFrom != null && widget.initialTo != null) {
      Future.wait([
        getCoordinatesFromAddress(widget.initialFrom!).then((c) => fromCoords = c),
        getCoordinatesFromAddress(widget.initialTo!).then((c) => toCoords = c),
      ]).then((_) {
        if (fromCoords != null && toCoords != null) fetchBusRoutes();
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
    const String apiKey = "pk.eyJ1IjoiZGF0MTUxMCIsImEiOiJjbTc4d3Rma3cwMTJyMnFvbGE4aGNsam5kIn0.2dAqovqd9va216DchFb4QQ";
    final url = Uri.parse("https://api.mapbox.com/geocoding/v5/mapbox.places/$address.json?access_token=$apiKey&country=VN&limit=1");
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
    return response.statusCode == 200
        ? List<Map<String, dynamic>>.from(json.decode(response.body))
        : [];
  }

  Future<void> fetchBusRoutes() async {
    if (fromCoords == null) fromCoords = await getCoordinatesFromAddress(_fromController.text);
    if (toCoords == null) toCoords = await getCoordinatesFromAddress(_toController.text);
    if (fromCoords == null || toCoords == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Không tìm thấy tọa độ!")));
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
        setState(() {
          busRoutes = json.decode(response.body);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
    } finally {
      setState(() => isFetchingRoutes = false);
    }
  }

  void _onFromChanged(String query) => _handleDebounce(query, isFrom: true);
  void _onToChanged(String query) => _handleDebounce(query, isFrom: false);

  void _handleDebounce(String query, {required bool isFrom}) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      final suggestions = await fetchAddressSuggestions(query);
      setState(() {
        if (isFrom) {
          fromSuggestions = suggestions;
        } else {
          toSuggestions = suggestions;
        }
      });
    });
  }

  Widget _buildSearchField({
    required String label,
    required TextEditingController controller,
    required void Function(String) onChanged,
    required List<Map<String, dynamic>> suggestions,
    required Function(Map<String, dynamic>) onSuggestionSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: const Icon(Icons.location_on,color: Colors.green,),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onChanged: onChanged,
        ),
        if (suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 5),
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                return ListTile(
                  title: Text(suggestion["name"]),
                  onTap: () => onSuggestionSelected(suggestion),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildRouteCard(dynamic route) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(route["Title"] ?? "Không có tiêu đề", style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(route["Desc"] ?? "Không có mô tả"),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BusRouteMapPage(
                routeData: route,
                fromLocation: _fromController.text,
                toLocation: _toController.text,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tìm tuyến xe buýt")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSearchField(
              label: "Điểm đi",
              controller: _fromController,
              onChanged: _onFromChanged,
              suggestions: fromSuggestions,
              onSuggestionSelected: (sug) {
                setState(() {
                  _fromController.text = sug["name"];
                  fromCoords = {
                    "longitude": double.parse(sug["longitude"].toString()),
                    "latitude": double.parse(sug["latitude"].toString()),
                  };
                  fromSuggestions.clear();
                });
              },
            ),
            const SizedBox(height: 12),
            _buildSearchField(
              label: "Điểm đến",
              controller: _toController,
              onChanged: _onToChanged,
              suggestions: toSuggestions,
              onSuggestionSelected: (sug) {
                setState(() {
                  _toController.text = sug["name"];
                  toCoords = {
                    "longitude": double.parse(sug["longitude"].toString()),
                    "latitude": double.parse(sug["latitude"].toString()),
                  };
                  toSuggestions.clear();
                });
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.search),
                label: const Text("Tìm tuyến xe buýt"),
                onPressed: fetchBusRoutes,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (isFetchingRoutes) const CircularProgressIndicator(),
            Expanded(
              child: busRoutes.isEmpty
                  ? const Center(child: Text("Không có dữ liệu"))
                  : ListView.builder(
                itemCount: busRoutes.length,
                itemBuilder: (_, i) => _buildRouteCard(busRoutes[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

