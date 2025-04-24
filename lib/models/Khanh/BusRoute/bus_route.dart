class BusRoute {
  final int routeId;
  final String routeName;
  final String routeNo;

  BusRoute({
    required this.routeId,
    required this.routeName,
    required this.routeNo,
  });

  factory BusRoute.fromMap(Map<String, dynamic> map) {
    return BusRoute(
      routeId: int.parse(map['RouteId']),
      routeName: map['RouteName'] ?? 'Không có tên tuyến',
      routeNo: map['RouteNo'] ?? 'Không có mã tuyến',
    );
  }

  factory BusRoute.fromJson(Map<String, dynamic> json) {
    return BusRoute(
      routeId: json['RouteId'],
      routeName: json['RouteName'] ?? 'Không có tên tuyến',
      routeNo: json['RouteNo'] ?? 'Không có mã tuyến',
    );
  }

  @override
  String toString() {
    return 'BusRoute(RouteId: $routeId, RouteName: $routeName, RouteNo: $routeNo)';
  }
}