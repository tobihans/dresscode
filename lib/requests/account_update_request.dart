import 'dart:convert';

import 'package:dresscode/requests/body_request.dart';

class AccountUpdateRequest extends BodyRequest {
  final String firstName;
  final String lastName;
  final String phone;

  const AccountUpdateRequest({
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  @override
  String toJson() {
    final Map<String, String> accountUpdateData = {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
    };
    return jsonEncode(accountUpdateData);
  }
}
