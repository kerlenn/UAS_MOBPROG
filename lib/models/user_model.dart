class User {
  final String? id;
  final String username;
  final String email;
  final String phone;
  final String? token;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.phone,
    this.token,
  });

  // Convert User object ke JSON (untuk kirim ke API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'token': token,
    };
  }

  // Convert JSON dari API ke User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString(),
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      token: json['token'],
    );
  }

  // Convert ke Map untuk simpan di SharedPreferences
  Map<String, String> toMap() {
    return {
      'id': id ?? '',
      'username': username,
      'email': email,
      'phone': phone,
      'token': token ?? '',
    };
  }

  // Convert dari Map (dari SharedPreferences)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      token: map['token'],
    );
  }
}