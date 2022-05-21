import 'dart:convert';

import 'package:dresscode/requests/body_request.dart';

class ForgotPasswordRequest extends BodyRequest {
  final String email;

  const ForgotPasswordRequest({required this.email});

  @override
  String toJson() {
    return jsonEncode({'email': email});
  }
}
