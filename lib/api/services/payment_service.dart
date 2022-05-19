import 'dart:convert';

import 'package:dresscode/api/core/api_base.dart';
import 'package:dresscode/api/core/constants.dart';
import 'package:dresscode/models/page.dart';
import 'package:dresscode/models/payment.dart';
import 'package:dresscode/requests/page_request.dart';

class PaymentService extends ApiBase {
  final String _token;

  PaymentService(this._token);

  Future<Page<Payment>> getPayments(PageRequest pageRequest) async {
    final apiResponse = await get(
      Uri.parse(Constants.clientPaymentsUrl),
      queryParams: pageRequest.toMap(),
      token: _token
    );
    final content = jsonEncode(jsonDecode(apiResponse)['content']);
    return Page<Payment>.fromJson(content);
  }
}