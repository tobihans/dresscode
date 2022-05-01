import 'dart:convert';
import 'dart:io';

import 'package:dresscode/api/core/api_http_exception.dart';
import 'package:dresscode/api/core/constants.dart';
import 'package:dresscode/api/core/http_methods.dart';
import 'package:dresscode/utils/string_extensions.dart';
import 'package:logging/logging.dart';

abstract class ApiBase {
  static final httpClient = HttpClient();
  final logger = Logger('$ApiBase');

  Future<String> callUrl(final Uri uri, final HttpMethod httpMethod,
      [final String data = '', final String token = '']) async {
    try {
      final request = await httpClient.openUrl(httpMethod.name, uri);
      request.headers.contentType = ContentType.json;
      request.headers.add('Accept', 'application/json');
      if (!token.isNullOrBlank) {
        request.headers.add('Authorization', 'Bearer $token');
      }
      if (!data.isNullOrBlank) {
        request.contentLength = data.length;
        request.write(data);
      }
      final response = await request.close();
      final responseContent = await response.transform(utf8.decoder).join('');
      final code = response.statusCode;
      logger.info(
          '(${httpMethod.name}) : [${uri.toString()}] => $code  : $responseContent');
      if (code >= 400) {
        final message = jsonDecode(responseContent)['message'];
        logger.severe('$code : $message');
        throw ApiHttpException(httpCode: code, message: message);
      }
      return responseContent;
    } on Exception catch (e) {
      logger.severe('Exception of type : ${e.runtimeType.toString()}');
      rethrow;
    }
  }

  Future<String> get(final Uri uri,
      {final Map<String, String> queryParams = Constants.emptyMap,
      final String data = '',
      String token = ''}) {
    if (queryParams.isEmpty) {
      return callUrl(uri, HttpMethod.get, data, token);
    } else {
      final queryString =
          queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');
      final uriToCall = Uri.parse(uri.toString() + '?$queryString');
      return callUrl(uriToCall, HttpMethod.get, data, token);
    }
  }

  Future<String> post(Uri uri, {String data = '', String token = ''}) async {
    return callUrl(uri, HttpMethod.post, data, token);
  }

  Future<String> put(Uri uri, {String data = '', String token = ''}) async {
    return callUrl(uri, HttpMethod.put, data, token);
  }

  Future<String> delete(Uri uri, {String data = '', String token = ''}) async {
    return callUrl(uri, HttpMethod.delete, data, token);
  }
}
