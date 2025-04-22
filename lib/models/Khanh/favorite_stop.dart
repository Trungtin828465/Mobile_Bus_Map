class FavoriteStop {
  final String id;
  final String stopId;
  final String stopName;

  FavoriteStop({
    required this.id,
    required this.stopId,
    required this.stopName,
  });

  factory FavoriteStop.fromJson(Map<String, dynamic> json) {
    return FavoriteStop(
      id: json['id']?.toString() ?? '',
      stopId: json['stopId']?.toString() ?? '',
      stopName: json['stopName']?.toString() ?? '',
    );
  }
}