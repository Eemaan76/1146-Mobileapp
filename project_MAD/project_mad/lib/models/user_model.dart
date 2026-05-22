class UserModel {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String role; // 'Renter' or 'Landlord'
  final String password;
  final String? avatar;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.password,
    this.avatar,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'password': password,
      'avatar': avatar,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return UserModel(
      id: docId ?? map['id'],
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? 'Renter',
      password: map['password'] ?? '',
      avatar: map['avatar'],
    );
  }
}
