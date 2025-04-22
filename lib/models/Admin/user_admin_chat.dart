class UserAdminChat {
  final String id;
  final int userId;
  final int adminId;
  final String title;
  final DateTime createdAt;
  final DateTime? lastMessageAt;

  UserAdminChat({
    required this.id,
    required this.userId,
    required this.adminId,
    required this.title,
    required this.createdAt,
    this.lastMessageAt,
  });
  factory UserAdminChat.fromJson(Map<String, dynamic> json) {
    return UserAdminChat(
      id: json['Id']?.toString() ?? '',
      userId: json['UserId'] != null ? int.parse(json['UserId'].toString()) : 0,
      adminId: json['AdminId'] != null ? int.parse(json['AdminId'].toString()) : 0,
      title: json['Title']?.toString() ?? '',
      createdAt: json['CreatedAt'] != null ? DateTime.parse(json['CreatedAt']) : DateTime.now(),
      lastMessageAt: json['LastMessageAt'] != null ? DateTime.parse(json['LastMessageAt']) : null,
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