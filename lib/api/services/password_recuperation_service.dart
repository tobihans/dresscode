import 'dart:convert';

import 'package:dresscode/api/core/api_base.dart';
import 'package:dresscode/api/core/constants.dart';
import 'package:dresscode/requests/forgot_password_request.dart';
import 'package:dresscode/requests/password_reset_request.dart';

class PasswordRecuperationService extends ApiBase {
  Future<void> startPasswordResetProcess(
    ForgotPasswordRequest forgotPasswordRequest,
  ) async {
    await post(
      Uri.parse(Constants.forgotPasswordUrl),
      data: forgotPasswordRequest.toJson(),
    );
  }

  Future<bool> resetUserPassword(
    PasswordResetRequest passwordResetRequest,
  ) async {
    final passwordResetResponse = await post(
      Uri.parse(Constants.passwordResetUrl),
      data: passwordResetRequest.toJson(),
    );
    return jsonDecode(passwordResetResponse)['content'] == 'Password changed';
  }
}
