class PageRequest {
  final int pageNumber;
  final int pageSize;

  PageRequest({
    required this.pageNumber,
    required this.pageSize,
  });

  Map<String, String> toMap() {
    return {
      'pageNumber': pageNumber.toString(),
      'pageSize': pageSize.toString()
    };
  }
}
