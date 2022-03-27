import 'dart:convert';

import 'package:dresscode/requests/body_request.dart';

class RegisterRequest extends BodyRequest {
  final String email;
  final String name;
  final String phone;
  final String password;

  RegisterRequest({
    required this.email,
    required this.name,
    required this.phone,
    required this.password,
  });

  @override
  String toJson() {
    final Map<String, String> registerData = {
      'email': email,
      'name': name,
      'phone': phone,
      'password': password,
    };
    return jsonEncode(registerData);
  }
}
