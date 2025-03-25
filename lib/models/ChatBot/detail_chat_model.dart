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
      id: json['id'] ?? '',
      role: json['role'] ?? '',
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      chatId: json['chatId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'chatId': chatId,
    };
  }
}