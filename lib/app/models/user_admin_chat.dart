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
      id: json['id']?.toString() ?? '',
      userId: json['userId'] != null ? int.parse(json['userId'].toString()) : 0,
      adminId: json['adminId'] != null ? int.parse(json['adminId'].toString()) : 0,
      title: json['title']?.toString() ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      lastMessageAt: json['lastMessageAt'] != null ? DateTime.parse(json['lastMessageAt']) : null,
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