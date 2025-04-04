class BusRoute {
  final String title;
  final String desc;

  final List<dynamic> stops;

  BusRoute({
    required this.title,
    required this.desc,

    required this.stops,
  });

  factory BusRoute.fromJson(Map<String, dynamic> json) {
    return BusRoute(
      title: json['Title'] ?? 'Không có tiêu đề',
      desc: json['Desc'] ?? 'Không có mô tả',
      stops: json['stops'] ?? [],
    );
  }
}