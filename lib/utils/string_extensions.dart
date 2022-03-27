extension StringExtensions on String? {
  bool get isNullOrBlank => this?.trim().isEmpty ?? true;
}