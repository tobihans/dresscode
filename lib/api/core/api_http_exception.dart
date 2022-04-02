class ApiHttpException implements Exception {
  final int httpCode;
  final String message;
  const ApiHttpException({required this.httpCode, required this.message});
}