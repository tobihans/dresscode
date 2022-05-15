class PageRequest {
   int pageNumber = 0;
   int pageSize = 20;

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
