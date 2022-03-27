import 'dart:convert';

import 'package:dresscode/api/api_base.dart';
import 'package:dresscode/api/core/constants.dart';
import 'package:dresscode/requests/login_request.dart';
import 'package:dresscode/requests/register_request.dart';

class AuthService extends ApiBase {
  Future<bool> register(RegisterRequest registerRequest) async {
    final registerResponse = await post(
      Uri.parse(Constants.registerUrl),
      registerRequest.toJson(),
    );
    return jsonDecode(registerResponse)['message'] == 'User created successfully';
  }

  Future<String> login(LoginRequest loginRequest) async {
    final loginResponse = await post(
      Uri.parse(Constants.loginUrl),
      loginRequest.toJson(),
    );
    return (jsonDecode(loginResponse)['content']).toString().split(' ').last;
  }
}
