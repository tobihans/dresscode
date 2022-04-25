import 'dart:convert';

import 'package:dresscode/api/core/api_base.dart';
import 'package:dresscode/api/core/api_http_exception.dart';
import 'package:dresscode/api/core/constants.dart';
import 'package:dresscode/models/user.dart';
import 'package:dresscode/requests/login_request.dart';
import 'package:dresscode/requests/register_request.dart';

class AuthService extends ApiBase {
  static User? _currentUser;

  Future<bool> register(RegisterRequest registerRequest) async {
    final registerResponse = await post(
      Uri.parse(Constants.registerUrl),
      registerRequest.toJson(),
    );
    return jsonDecode(registerResponse)['message'] ==
        'User created successfully';
  }

  Future<String> login(LoginRequest loginRequest) async {
    final loginResponse = await post(
      Uri.parse(Constants.loginUrl),
      loginRequest.toJson(),
    );
    return (jsonDecode(loginResponse)['content']).toString().split(' ').last;
  }

  Future<User?> getCurrentUser(String token) async {
    if (_currentUser == null) {
      try {
        final userData = await get(
            Uri.parse(Constants.currentUserUrl), Constants.emptyMap, '', token);
        final userJson = jsonEncode(jsonDecode(userData)['content']);
        _currentUser = User.fromJson(userJson);
        return _currentUser;
      } on ApiHttpException {
        return null;
      }
    }
    return _currentUser;
  }

  Future<void> logout() async {
    _currentUser = null;
  }
}
