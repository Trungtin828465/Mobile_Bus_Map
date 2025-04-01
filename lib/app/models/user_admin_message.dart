class UserAdminMessage {
  final String id;
  final String chatId;
  final String senderRole; // "User" hoặc "Admin"
  final String content;
  final DateTime sentAt;
  final bool isRead;

  UserAdminMessage({
    required this.id,
    required this.chatId,
    required this.senderRole,
    required this.content,
    required this.sentAt,
    required this.isRead,
  });

  factory UserAdminMessage.fromJson(Map<String, dynamic> json) {
    return UserAdminMessage(
      id: json['id']?.toString() ?? '',
      chatId: json['chatId']?.toString() ?? '',
      senderRole: json['senderRole'] ?? '',
      content: json['content'] ?? '',
      sentAt: DateTime.parse(json['sentAt'] ?? DateTime.now().toIso8601String()),
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderRole': senderRole,
      'content': content,
      'sentAt': sentAt.toIso8601String(),
      'isRead': isRead,
    };
  }
}