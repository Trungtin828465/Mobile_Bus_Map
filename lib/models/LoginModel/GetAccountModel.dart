class Account {
   int id;
   String fullName;
   String email;
   String numberPhone;
   String password;

  Account({
    required this.id,
    required this.fullName,
    required this.email,
    required this.numberPhone,
    required this.password,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['Id'],
      fullName: json['FullName'],
      email: json['Email'],
      numberPhone: json['NumberPhone'],
      password: json['Password'],
    );
  }
  // Thêm phương thức toJson để gửi dữ liệu lên API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'numberPhone': numberPhone,
      'password': password,
      'tripHistories': {'\$values': []}, // Dữ liệu mẫu, bạn có thể bỏ nếu API không yêu cầu
    };
  }
}