class FavoriteRoute {
  final String id;
  final int userId;
  final String routeNo;
  final String routeName;

  FavoriteRoute({
    required this.id,
    required this.userId,
    required this.routeNo,
    required this.routeName,
  });

  factory FavoriteRoute.fromJson(Map<String, dynamic> json) {
    return FavoriteRoute(
      id: json['Id']?.toString() ?? '',
      userId: json['UserId'] ?? 0,
      routeNo: json['RouteNo']?.toString() ?? '',
      routeName: json['RouteName']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'UserId': userId,
      'RouteNo': routeNo,
      'RouteName': routeName,
    };
  }
}