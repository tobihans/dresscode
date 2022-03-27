class ApiHttpException implements Exception {
  final int httpCode;
  final String message;
  ApiHttpException({required this.httpCode, required this.message});
}