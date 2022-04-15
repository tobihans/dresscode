import 'dart:convert';

import 'package:dresscode/requests/body_request.dart';

class RegisterRequest extends BodyRequest {
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String password;

  const RegisterRequest({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.password,
  });

  @override
  String toJson() {
    final Map<String, String> registerData = {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'password': password,
    };
    return jsonEncode(registerData);
  }
}
