class BusStopModel {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String? address;

  BusStopModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory BusStopModel.fromJson(Map<String, dynamic> json) {
    return BusStopModel(
      id: json['Id'],
      name: json['Name'],
      latitude: json['Latitude'],
      longitude: json['Longitude'],
      address: json['Address'],
    );
  }
}
