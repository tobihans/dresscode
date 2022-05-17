import 'dart:convert';

import 'package:dresscode/requests/body_request.dart';

class PasswordUpdateRequest extends BodyRequest {
  final String password;
  final String newPassword;

  const PasswordUpdateRequest({
    required this.password,
    required this.newPassword,
  });

  @override
  String toJson() {
    final Map<String, String> passwordUpdateData = {
      'password': password,
      'new_password': newPassword,
    };
    return jsonEncode(passwordUpdateData);
  }
}
