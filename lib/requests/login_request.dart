import 'dart:convert';

import 'package:dresscode/requests/body_request.dart';

class LoginRequest extends BodyRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  @override
  String toJson() {
    final Map<String, String> loginData = {
      'email': email,
      'password': password,
    };
    return jsonEncode(loginData);
  }
}
