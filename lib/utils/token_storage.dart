import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';

class TokenStorage {
  static String? _token;
  static const String tokenKey = 'token';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static final Logger _logger = Logger('$TokenStorage');

  static Future<void> saveToken(String token) async {
    _logger.info('Saving token');
    _token = token;
    await _storage.write(key: tokenKey, value: token);
  }

  static Future<String> getToken() async {
    _logger.info('Getting token');
    _token ??= await _storage.read(key: tokenKey);
    return _token ?? '';
  }

  static Future<bool> hasToken() async {
    return await _storage.containsKey(key: tokenKey);
  }

  static Future<void> removeToken() async {
    _logger.info('Removing token');
    _token = null;
    await _storage.delete(key: tokenKey);
  }
}
