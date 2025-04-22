class ChatModel {
  final String id;
  final int userId;
  final String title;
  final DateTime createdAt;

  ChatModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.createdAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['Id'] ?? '',
      userId: json['UserId'] ?? 0,
      title: json['Title'] ?? '',
      createdAt: DateTime.parse(json['CreatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}