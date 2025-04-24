// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:busmap/providers/Khanh/favorite_provider.dart';
//
// class FavoriteScreen extends StatefulWidget {
//   const FavoriteScreen({super.key});
//
//   @override
//   _FavoriteScreenState createState() => _FavoriteScreenState();
// }
//
// class _FavoriteScreenState extends State<FavoriteScreen> with SingleTickerProviderStateMixin {
//   String _searchQuery = '';
//   final int _userId = 1;
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this); // Khởi tạo TabController với 2 tab
//     // Lấy danh sách yêu thích khi khởi tạo
//     final favoriteProvider = Provider.of<FavoriteProvider>(context, listen: false);
//     favoriteProvider.fetchFavoriteRoutes(_userId);
//     favoriteProvider.fetchFavoriteStops(_userId);
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _deleteFavoriteRoute(String id) async {
//     await Provider.of<FavoriteProvider>(context, listen: false)
//         .deleteFavoriteRoute(_userId, id);
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Đã xóa tuyến khỏi danh sách yêu thích')),
//     );
//   }
//
//   Future<void> _deleteFavoriteStop(String id) async {
//     await Provider.of<FavoriteProvider>(context, listen: false)
//         .deleteFavoriteStop(_userId, id);
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Đã xóa trạm dừng khỏi danh sách yêu thích')),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Danh sách yêu thích'),
//         backgroundColor: Colors.green,
//         elevation: 0,
//         bottom: TabBar(
//           controller: _tabController,
//           labelColor: Colors.white,
//           unselectedLabelColor: Colors.white70,
//           indicatorColor: Colors.white,
//           tabs: const [
//             Tab(text: 'Tuyến'),
//             Tab(text: 'Trạm dừng'),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               decoration: const InputDecoration(
//                 labelText: 'Tìm kiếm',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.search),
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   _searchQuery = value.toLowerCase();
//                 });
//               },
//             ),
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 // Tab 2: Tuyến
//                 RefreshIndicator(
//                   onRefresh: () async {
//                     await Provider.of<FavoriteProvider>(context, listen: false)
//                         .fetchFavoriteRoutes(_userId);
//                   },
//                   child: Consumer<FavoriteProvider>(
//                     builder: (context, favoriteProvider, child) {
//                       if (favoriteProvider.isLoadingRoutes) {
//                         return const Center(child: CircularProgressIndicator());
//                       } else if (favoriteProvider.errorRoutes != null) {
//                         String errorMessage = favoriteProvider.errorRoutes!;
//                         if (errorMessage.contains('Connection closed')) {
//                           errorMessage = 'Không thể kết nối đến server. Vui lòng kiểm tra server hoặc kết nối mạng.';
//                         } else if (errorMessage.contains('404')) {
//                           errorMessage = 'Không tìm thấy dữ liệu. Vui lòng thử lại sau.';
//                         }
//                         return Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 errorMessage,
//                                 style: const TextStyle(color: Colors.red, fontSize: 16),
//                                 textAlign: TextAlign.center,
//                               ),
//                               const SizedBox(height: 10),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   favoriteProvider.fetchFavoriteRoutes(_userId);
//                                 },
//                                 child: const Text('Thử lại'),
//                               ),
//                             ],
//                           ),
//                         );
//                       } else if (favoriteProvider.favoriteRoutes.isEmpty) {
//                         return const Center(
//                           child: Text(
//                             'Bạn chưa có tuyến yêu thích',
//                             style: TextStyle(color: Colors.grey, fontSize: 16),
//                           ),
//                         );
//                       }
//
//                       final routes = favoriteProvider.favoriteRoutes
//                           .where((route) => route.routeNo.toLowerCase().contains(_searchQuery))
//                           .toList();
//
//                       return ListView.builder(
//                         itemCount: routes.length,
//                         itemBuilder: (context, index) {
//                           final route = routes[index];
//                           return ListTile(
//                             title: Text(route.routeName.isNotEmpty ? route.routeName : 'Không có tên tuyến'),
//                             subtitle: Text(
//                               'Mã tuyến: ${route.routeNo.isNotEmpty ? route.routeNo : 'Không có mã tuyến'}',
//                             ),
//                             trailing: IconButton(
//                               icon: const Icon(Icons.delete, color: Colors.red),
//                               onPressed: () => _deleteFavoriteRoute(route.id),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 // Tab 1: Trạm dừng
//                 RefreshIndicator(
//                   onRefresh: () async {
//                     await Provider.of<FavoriteProvider>(context, listen: false)
//                         .fetchFavoriteStops(_userId);
//                   },
//                   child: Consumer<FavoriteProvider>(
//                     builder: (context, favoriteProvider, child) {
//                       if (favoriteProvider.isLoadingStops) {
//                         return const Center(child: CircularProgressIndicator());
//                       } else if (favoriteProvider.errorStops != null) {
//                         String errorMessage = favoriteProvider.errorStops!;
//                         if (errorMessage.contains('Connection closed')) {
//                           errorMessage = 'Không thể kết nối đến server. Vui lòng kiểm tra server hoặc kết nối mạng.';
//                         } else if (errorMessage.contains('404')) {
//                           errorMessage = 'Không tìm thấy dữ liệu. Vui lòng thử lại sau.';
//                         }
//                         return Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 errorMessage,
//                                 style: const TextStyle(color: Colors.red, fontSize: 16),
//                                 textAlign: TextAlign.center,
//                               ),
//                               const SizedBox(height: 10),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   favoriteProvider.fetchFavoriteStops(_userId);
//                                 },
//                                 child: const Text('Thử lại'),
//                               ),
//                             ],
//                           ),
//                         );
//                       } else if (favoriteProvider.favoriteStops.isEmpty) {
//                         return const Center(
//                           child: Text(
//                             'Bạn chưa có trạm dừng yêu thích',
//                             style: TextStyle(color: Colors.grey, fontSize: 16),
//                           ),
//                         );
//                       }
//
//                       final stops = favoriteProvider.favoriteStops
//                           .where((stop) => stop.stopName.toLowerCase().contains(_searchQuery))
//                           .toList();
//
//                       return ListView.builder(
//                         itemCount: stops.length,
//                         itemBuilder: (context, index) {
//                           final stop = stops[index];
//                           return ListTile(
//                             title: Text(stop.stopName.isNotEmpty ? stop.stopName : 'Không có tên trạm'),
//                             subtitle: Text(
//                               'Mã trạm: ${stop.stopId.isNotEmpty ? stop.stopId : 'Không có mã trạm'}',
//                             ),
//                             trailing: IconButton(
//                               icon: const Icon(Icons.delete, color: Colors.red),
//                               onPressed: () => _deleteFavoriteStop(stop.id),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// FavoriteScreen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:busmap/providers/Khanh/favorite_provider.dart';
import 'package:fluro/fluro.dart';
import 'package:busmap/Router.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with SingleTickerProviderStateMixin {
  final int _userId = 1; // TODO: lấy userId runtime
  late TabController _tabController;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final fav = context.read<FavoriteProvider>();
    fav.fetchFavoriteRoutes(_userId);
    fav.fetchFavoriteStops(_userId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // —— helpers ——————————————————————————
  Widget _buildSearchBar() => Padding(
    padding: const EdgeInsets.all(12),
    child: TextField(
      onChanged: (v) => setState(() => _search = v.toLowerCase()),
      decoration: InputDecoration(
        hintText: 'Tìm kiếm...',
        prefixIcon: const Icon(Icons.search),
        border:
        OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        filled: true,
        fillColor: Colors.white,
      ),
    ),
  );

  Widget _buildEmpty(String msg) => Center(
    child: Text(msg,
        style: const TextStyle(fontSize: 16, color: Colors.grey)),
  );

  Widget _buildError(String msg, VoidCallback retry) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(msg,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.red)),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: retry, child: const Text('Thử lại')),
      ],
    ),
  );

  // ———— card giống BusSelectRount —————————
  Widget _busCard({
    required String id,
    required String routeNo,
    required String routeName,
    required VoidCallback onDelete,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.directions_bus, color: Colors.blue),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tuyến xe: $routeNo',
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(routeName,
                style: const TextStyle(fontSize: 14, color: Colors.black87)),
          ],
        ),
        trailing:
        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
        onTap: () => FluroRouterConfig.router.navigateTo(
          context,
          "/busDetail/$routeNo",
          transition: TransitionType.fadeIn,
        ),
      ),
    );
  }

  Widget _stopCard({
    required String id,
    required String stopId,
    required String stopName,
    required VoidCallback onDelete,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.location_on, color: Colors.green),
        title: Text(stopName,
            style:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text('Mã trạm: $stopId'),
        trailing:
        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
      ),
    );
  }

  // ———— list builder (route/stop) —————————
  Widget _buildRouteTab(FavoriteProvider fav) {
    if (fav.isLoadingRoutes) return const Center(child: CircularProgressIndicator());
    if (fav.errorRoutes != null) {
      return _buildError(fav.errorRoutes!, () => fav.fetchFavoriteRoutes(_userId));
    }
    final data = fav.favoriteRoutes
        .where((r) => r.routeNo.toLowerCase().contains(_search) || r.routeName.toLowerCase().contains(_search))
        .toList();
    if (data.isEmpty) return _buildEmpty('Không có tuyến yêu thích');
    return RefreshIndicator(
      onRefresh: () => fav.fetchFavoriteRoutes(_userId),
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (_, i) {
          final r = data[i];
          return _busCard(
            id: r.id,
            routeNo: r.routeNo,
            routeName: r.routeName,
            onDelete: () async {
              await fav.deleteFavoriteRoute(_userId, r.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Đã xóa tuyến khỏi yêu thích')));
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildStopTab(FavoriteProvider fav) {
    if (fav.isLoadingStops) return const Center(child: CircularProgressIndicator());
    if (fav.errorStops != null) {
      return _buildError(fav.errorStops!, () => fav.fetchFavoriteStops(_userId));
    }
    final data = fav.favoriteStops
        .where((s) => s.stopName.toLowerCase().contains(_search))
        .toList();
    if (data.isEmpty) return _buildEmpty('Không có trạm yêu thích');
    return RefreshIndicator(
      onRefresh: () => fav.fetchFavoriteStops(_userId),
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (_, i) {
          final s = data[i];
          return _stopCard(
            id: s.id,
            stopId: s.stopId,
            stopName: s.stopName,
            onDelete: () async {
              await fav.deleteFavoriteStop(_userId, s.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Đã xóa trạm khỏi yêu thích')));
              }
            },
          );
        },
      ),
    );
  }

  // ———— build —————————
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Danh sách yêu thích', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        // Giả sử router của bạn đã đăng ký route '/homeMaster'
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Nếu chỉ muốn thêm màn hình homeMaster lên trên stack
            Navigator.pushNamed(context, '/homeMaster');

          },
        ),

        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Tuyến'),
            Tab(text: 'Trạm dừng'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: Consumer<FavoriteProvider>(
              builder: (_, fav, __) => TabBarView(
                controller: _tabController,
                children: [
                  _buildRouteTab(fav),
                  _buildStopTab(fav),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
