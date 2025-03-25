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
      id: json['id']?.toString() ?? '',
      userId: json['userId'] ?? 0,
      routeNo: json['routeNo']?.toString() ?? '',
      routeName: json['routeName']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'routeNo': routeNo,
      'routeName': routeName,
    };
  }
}