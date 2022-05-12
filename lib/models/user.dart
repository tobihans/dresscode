import 'dart:convert';

import 'package:dresscode/models/serializable.dart';

class User extends Serializable {
  final String name;
  final String email;
  final String phone;
  final String? code;

  const User({
    required this.name,
    required this.email,
    required this.phone,
    this.code,
  });

  @override
  User.fromMap(final Map<String, dynamic> map)
      : name = map['name'] as String,
        email = map['email'] as String,
        phone = map['phone'] as String,
        code = map['code'] as String?;

  @override
  factory User.fromJson(final String json) {
    final Map<String, dynamic> userData = jsonDecode(json);
    return User(
      name: userData['name'] as String,
      email: userData['email'] as String,
      phone: userData['phone'] as String,
      code: userData['code'] as String?,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'phone': phone,
        'code': code,
      };
}
