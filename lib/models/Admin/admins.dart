class Admin {
  final int id;
  final String FullName;
  final String Email;
  final String Password;
  final String NumberPhone;

  Admin({
    required this.id,
    required this.FullName,
    required this.Email,
    required this.Password,
    required this.NumberPhone,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'],
      FullName: json['fullName'],
      Email: json['email'],
      Password: json['password'],
      NumberPhone: json['numberPhone'],
    );
  }
}