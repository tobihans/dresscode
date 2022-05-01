class ApiHttpException implements Exception {
  final int httpCode;
  final String message;

  const ApiHttpException({required this.httpCode, required this.message});

  bool get isAuthException => httpCode == 403 || httpCode == 401;

  @override
  String toString() {
    return 'ApiHttpException{httpCode: $httpCode, message: $message}';
  }
}
