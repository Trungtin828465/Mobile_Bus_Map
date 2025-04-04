import 'package:flutter/material.dart';
import 'package:utilitybus/controllers/busroute_trip_controller.dart';
import 'package:utilitybus/views/widgets/suggestion_trip.dart';
import 'package:utilitybus/views/bus_route_map_page.dart';
import 'package:utilitybus/models/route_model.dart';
import '../controllers/map_controller.dart';

class BusRouteFinderView extends StatefulWidget {
  final String? initialFrom;
  final String? initialTo;

  const BusRouteFinderView({this.initialFrom, this.initialTo, super.key});

  @override
  State<BusRouteFinderView> createState() => _BusRouteFinderViewState();
}

class _BusRouteFinderViewState extends State<BusRouteFinderView> {
  final BusRouteController _controller = BusRouteController();
  late TextEditingController _fromController;
  late TextEditingController _toController;

  // Danh sách màu sắc cho các tuyến xe buýt
  final List<Color> routeColors = [
    Colors.blue,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.amber,
    Colors.cyan,
  ];

  @override
  void initState() {
    super.initState();
    _fromController = TextEditingController(text: widget.initialFrom);
    _toController = TextEditingController(text: widget.initialTo);

    if ((widget.initialFrom?.isNotEmpty ?? false) &&
        (widget.initialTo?.isNotEmpty ?? false)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.fetchBusRoutes(
            context,
            widget.initialFrom!,
            widget.initialTo!,
            setState,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _fromController,
                        icon: Icons.location_pin,
                        iconColor: Colors.red,
                        hint: "Nhập địa điểm đi",
                        onChanged: (value) => _controller.onFromChanged(value, setState),
                        onSubmitted: () {
                          setState(() => _controller.clearFromSuggestions());
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: _toController,
                        icon: Icons.location_on,
                        iconColor: Colors.black,
                        hint: "Nhập địa điểm đến",
                        onChanged: (value) => _controller.onToChanged(value, setState),
                        onSubmitted: () {
                          setState(() => _controller.clearToSuggestions());
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () => _controller.fetchBusRoutes(
                          context,
                          _fromController.text.trim(),
                          _toController.text.trim(),
                          setState,
                        ),
                        child: const Text("Tìm Đường"),
                      ),
                    ],
                  ),
                ),
              ),
              if (_controller.hasFromSuggestions)
                SuggestionListWidget(
                  suggestions: _controller.fromSuggestions,
                  onSelect: (suggestion) => _controller.selectFromSuggestion(
                    suggestion,
                    setState,
                    _fromController,
                  ),
                ),
              if (_controller.hasToSuggestions)
                SuggestionListWidget(
                  suggestions: _controller.toSuggestions,
                  onSelect: (suggestion) => _controller.selectToSuggestion(
                    suggestion,
                    setState,
                    _toController,
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: _controller.busRoutes.length,
                  itemBuilder: (context, index) {
                    final route = _controller.busRoutes[index];
                    // Lấy màu từ danh sách, sử dụng modulo để lặp lại nếu vượt quá số màu
                    final routeColor = routeColors[index % routeColors.length];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BusRouteMapPage(
                              routeStops: route.stops,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: routeColor, // Sử dụng màu động
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.directions_bus,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        route.title ?? 'Unknown Route',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Divider(color: Colors.grey.shade300),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.red,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    route.desc ?? 'No description available',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          if (_controller.isFetchingRoutes)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required Color iconColor,
    required String hint,
    required Function(String) onChanged,
    required Function() onSubmitted,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.green.shade700,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white),
        prefixIcon: Icon(icon, color: iconColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
      onChanged: onChanged,
      onSubmitted: (_) => onSubmitted(),
    );
  }
}