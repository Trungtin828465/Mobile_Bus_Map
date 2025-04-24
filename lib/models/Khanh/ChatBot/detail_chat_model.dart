class DetailChatModel {
  final String id;
  final String role;
  final String content;
  final DateTime createdAt;
  final String chatId;

  DetailChatModel({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    required this.chatId,
  });

  factory DetailChatModel.fromJson(Map<String, dynamic> json) {
    return DetailChatModel(
      id: json['Id'] ?? '',
      role: json['Role'] ?? '',
      content: json['Content'] ?? '',
      createdAt: DateTime.parse(json['CreatedAt'] ?? DateTime.now().toIso8601String()),
      chatId: json['ChatId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Role': role,
      'Content': content,
      'CreatedAt': createdAt.toIso8601String(),
      'ChatId': chatId,
    };
  }
}