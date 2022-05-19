import 'dart:convert';

import 'package:dresscode/api/core/api_base.dart';
import 'package:dresscode/api/core/api_http_exception.dart';
import 'package:dresscode/api/core/constants.dart';
import 'package:dresscode/models/user.dart';
import 'package:dresscode/requests/account_update_request.dart';
import 'package:dresscode/requests/login_request.dart';
import 'package:dresscode/requests/password_update_request.dart';
import 'package:dresscode/requests/picture_request.dart';
import 'package:dresscode/requests/register_request.dart';
import 'package:dresscode/utils/token_storage.dart';

class AuthService extends ApiBase {
  static User? _currentUser;

  Future<User?> getCurrentUser(String token) async {
    if (_currentUser == null) {
      try {
        final userData = await get(
          Uri.parse(Constants.currentUserUrl),
          token: token,
        );
        final userJson = jsonEncode(jsonDecode(userData)['content']);
        _currentUser = User.fromJson(userJson);
        return _currentUser;
      } on ApiHttpException {
        return null;
      }
    }
    return _currentUser;
  }

  static Future<User?> getUserFromTokenStorage() async {
    return await (AuthService().getCurrentUser(await TokenStorage.getToken()));
  }

  Future<bool> register(RegisterRequest registerRequest) async {
    final registerResponse = await post(
      Uri.parse(Constants.registerUrl),
      data: registerRequest.toJson(),
    );
    return jsonDecode(registerResponse)['message'] ==
        'User created successfully';
  }

  Future<String> login(LoginRequest loginRequest) async {
    final loginResponse = await post(
      Uri.parse(Constants.loginUrl),
      data: loginRequest.toJson(),
    );
    return (jsonDecode(loginResponse)['content']).toString().split(' ').last;
  }

  Future<void> updateUserAccount(
    AccountUpdateRequest accountUpdateRequest,
    String token,
  ) async {
    final updateResponse = await put(Uri.parse(Constants.accountUpdateUrl),
        data: accountUpdateRequest.toJson(), token: token);
    _currentUser = User.fromJson(
      jsonEncode(jsonDecode(updateResponse)['content']),
    );
  }

  Future<bool> updateUserPassword(
    PasswordUpdateRequest passwordUpdateRequest,
    String token,
  ) async {
    final updatePasswordResponse = await put(
      Uri.parse(Constants.passwordUpdateUrl),
      data: passwordUpdateRequest.toJson(),
      token: token,
    );
    return jsonDecode(updatePasswordResponse)['content'] == 'Password changed';
  }

  Future<void> updateUserPicture(
    PictureRequest pictureRequest,
    String token,
  ) async {
    final updateResponse = await put(
      Uri.parse(Constants.accountPictureUpdateUrl),
      data: pictureRequest.image,
      token: token,
    );
    _currentUser = User.fromJson(
      jsonEncode(jsonDecode(updateResponse)['content']),
    );
  }

  Future<void> logout() async {
    _currentUser = null;
  }
}
