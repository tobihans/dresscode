import 'dart:convert';

import 'package:dresscode/requests/body_request.dart';

class PasswordResetRequest extends BodyRequest {
  final String token;
  final String password;

  const PasswordResetRequest({
    required this.token,
    required this.password,
  });

  @override
  String toJson() {
    final Map<String,String> passwordResetData = {
      'token': token,
      'password': password
    };
    return jsonEncode(passwordResetData);
  }
}
