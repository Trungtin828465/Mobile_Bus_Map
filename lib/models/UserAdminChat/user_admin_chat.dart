class UserAdminChat {
  final String id;
  final int userId;
  final int adminId;
  final DateTime createdAt;

  UserAdminChat({
    required this.id,
    required this.userId,
    required this.adminId,
    required this.createdAt,
  });

  factory UserAdminChat.fromJson(Map<String, dynamic> json) {
    return UserAdminChat(
      id: json['id']?.toString() ?? '',
      userId: json['userId'] ?? 0,
      adminId: json['adminId'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'adminId': adminId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}