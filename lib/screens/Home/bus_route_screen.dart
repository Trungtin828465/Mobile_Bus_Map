import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:busmap/models/Khanh/BusRoute/bus_route.dart';
import 'package:busmap/service/Khanh/bus_route_service.dart';
// import 'package:busmap/screens/Home/bus_route_detail_screen.dart';
import 'package:busmap/providers/Khanh/favorite_provider.dart';
import 'package:busmap/screens/RouterBusStop/DetailBus.dart';



class BusRouteScreen extends StatefulWidget {
  const BusRouteScreen({super.key});

  @override
  _BusRouteScreenState createState() => _BusRouteScreenState();
}

class _BusRouteScreenState extends State<BusRouteScreen> {
  final BusRouteService _apiService = BusRouteService();
  late Future<List<BusRoute>> _routesFuture;
  String _searchQuery = '';
  final int _userId = 1;

  @override
  void initState() {
    super.initState();
    _routesFuture = _apiService.fetchBusRoutes();
    // Lấy danh sách yêu thích khi khởi tạo
    Provider.of<FavoriteProvider>(context, listen: false).fetchFavoriteRoutes(_userId);
  }

  Future<void> _addToFavorites(String routeNo, String routeName) async {
    try {
      await Provider.of<FavoriteProvider>(context, listen: false)
          .addFavoriteRoute(_userId, routeNo, routeName);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã thêm tuyến vào danh sách yêu thích')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách tuyến xe'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Tìm kiếm mã tuyến',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _routesFuture = _apiService.fetchBusRoutes();
                });
                await Provider.of<FavoriteProvider>(context, listen: false)
                    .fetchFavoriteRoutes(_userId);
              },
              child: FutureBuilder<List<BusRoute>>(
                future: _routesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    String errorMessage = snapshot.error.toString();
                    if (errorMessage.contains('XmlParserException')) {
                      errorMessage = 'Dữ liệu từ server không đúng định dạng XML. Vui lòng kiểm tra API.';
                    } else if (errorMessage.contains('Failed to load bus routes')) {
                      errorMessage = 'Không thể tải danh sách tuyến xe: $errorMessage';
                    }
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Lỗi: $errorMessage',
                            style: const TextStyle(color: Colors.red, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _routesFuture = _apiService.fetchBusRoutes();
                              });
                            },
                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'Không có tuyến xe nào',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  final routes = snapshot.data!
                      .where((route) => route.routeNo.toLowerCase().contains(_searchQuery))
                      .toList();

                  return Consumer<FavoriteProvider>(
                    builder: (context, favoriteProvider, child) {
                      if (favoriteProvider.isLoadingRoutes) { // Sửa từ isLoading thành isLoadingRoutes
                        return const Center(child: CircularProgressIndicator());
                      } else if (favoriteProvider.errorRoutes != null) { // Sửa từ error thành errorRoutes
                        return Center(
                          child: Text(
                            'Lỗi khi lấy danh sách yêu thích: ${favoriteProvider.errorRoutes}',
                            style: const TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        );
                      }

                      final favoriteRoutes = favoriteProvider.favoriteRoutes;

                      return ListView.builder(
                        itemCount: routes.length,
                        itemBuilder: (context, index) {
                          final route = routes[index];
                          final isFavorite = favoriteRoutes.any((fav) => fav.routeNo == route.routeNo);

                          return ListTile(
                            title: Text(route.routeName.isNotEmpty ? route.routeName : 'Không có tên tuyến'),
                            subtitle: Text(
                              'Mã tuyến: ${route.routeNo.isNotEmpty ? route.routeNo : 'Không có mã tuyến'}',
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BusDetailScreen(routeId: route.routeId.toString()),
                                ),
                              );
                            },
                            trailing: IconButton(
                              icon: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                if (!isFavorite) {
                                  _addToFavorites(route.routeNo, route.routeName);
                                }
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}