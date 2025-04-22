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
      id: json['Id']?.toString() ?? '',
      chatId: json['ChatId']?.toString() ?? '',
      senderRole: json['SenderRole'] ?? '',
      content: json['Content'] ?? '',
      sentAt: DateTime.parse(json['SentAt'] ?? DateTime.now().toIso8601String()),
      isRead: json['IsRead'] ?? false,
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