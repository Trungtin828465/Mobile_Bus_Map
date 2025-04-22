import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:busmap/providers/Khanh/favorite_provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  final int _userId = 1;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Khởi tạo TabController với 2 tab
    // Lấy danh sách yêu thích khi khởi tạo
    final favoriteProvider = Provider.of<FavoriteProvider>(context, listen: false);
    favoriteProvider.fetchFavoriteRoutes(_userId);
    favoriteProvider.fetchFavoriteStops(_userId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _deleteFavoriteRoute(String id) async {
    await Provider.of<FavoriteProvider>(context, listen: false)
        .deleteFavoriteRoute(_userId, id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xóa tuyến khỏi danh sách yêu thích')),
    );
  }

  Future<void> _deleteFavoriteStop(String id) async {
    await Provider.of<FavoriteProvider>(context, listen: false)
        .deleteFavoriteStop(_userId, id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xóa trạm dừng khỏi danh sách yêu thích')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách yêu thích'),
        backgroundColor: Colors.green,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Tuyến'),
            Tab(text: 'Trạm dừng'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Tìm kiếm',
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
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 2: Tuyến
                RefreshIndicator(
                  onRefresh: () async {
                    await Provider.of<FavoriteProvider>(context, listen: false)
                        .fetchFavoriteRoutes(_userId);
                  },
                  child: Consumer<FavoriteProvider>(
                    builder: (context, favoriteProvider, child) {
                      if (favoriteProvider.isLoadingRoutes) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (favoriteProvider.errorRoutes != null) {
                        String errorMessage = favoriteProvider.errorRoutes!;
                        if (errorMessage.contains('Connection closed')) {
                          errorMessage = 'Không thể kết nối đến server. Vui lòng kiểm tra server hoặc kết nối mạng.';
                        } else if (errorMessage.contains('404')) {
                          errorMessage = 'Không tìm thấy dữ liệu. Vui lòng thử lại sau.';
                        }
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                errorMessage,
                                style: const TextStyle(color: Colors.red, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  favoriteProvider.fetchFavoriteRoutes(_userId);
                                },
                                child: const Text('Thử lại'),
                              ),
                            ],
                          ),
                        );
                      } else if (favoriteProvider.favoriteRoutes.isEmpty) {
                        return const Center(
                          child: Text(
                            'Bạn chưa có tuyến yêu thích',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        );
                      }

                      final routes = favoriteProvider.favoriteRoutes
                          .where((route) => route.routeNo.toLowerCase().contains(_searchQuery))
                          .toList();

                      return ListView.builder(
                        itemCount: routes.length,
                        itemBuilder: (context, index) {
                          final route = routes[index];
                          return ListTile(
                            title: Text(route.routeName.isNotEmpty ? route.routeName : 'Không có tên tuyến'),
                            subtitle: Text(
                              'Mã tuyến: ${route.routeNo.isNotEmpty ? route.routeNo : 'Không có mã tuyến'}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteFavoriteRoute(route.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                // Tab 1: Trạm dừng
                RefreshIndicator(
                  onRefresh: () async {
                    await Provider.of<FavoriteProvider>(context, listen: false)
                        .fetchFavoriteStops(_userId);
                  },
                  child: Consumer<FavoriteProvider>(
                    builder: (context, favoriteProvider, child) {
                      if (favoriteProvider.isLoadingStops) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (favoriteProvider.errorStops != null) {
                        String errorMessage = favoriteProvider.errorStops!;
                        if (errorMessage.contains('Connection closed')) {
                          errorMessage = 'Không thể kết nối đến server. Vui lòng kiểm tra server hoặc kết nối mạng.';
                        } else if (errorMessage.contains('404')) {
                          errorMessage = 'Không tìm thấy dữ liệu. Vui lòng thử lại sau.';
                        }
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                errorMessage,
                                style: const TextStyle(color: Colors.red, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  favoriteProvider.fetchFavoriteStops(_userId);
                                },
                                child: const Text('Thử lại'),
                              ),
                            ],
                          ),
                        );
                      } else if (favoriteProvider.favoriteStops.isEmpty) {
                        return const Center(
                          child: Text(
                            'Bạn chưa có trạm dừng yêu thích',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        );
                      }

                      final stops = favoriteProvider.favoriteStops
                          .where((stop) => stop.stopName.toLowerCase().contains(_searchQuery))
                          .toList();

                      return ListView.builder(
                        itemCount: stops.length,
                        itemBuilder: (context, index) {
                          final stop = stops[index];
                          return ListTile(
                            title: Text(stop.stopName.isNotEmpty ? stop.stopName : 'Không có tên trạm'),
                            subtitle: Text(
                              'Mã trạm: ${stop.stopId.isNotEmpty ? stop.stopId : 'Không có mã trạm'}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteFavoriteStop(stop.id),
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
        ],
      ),
    );
  }
}