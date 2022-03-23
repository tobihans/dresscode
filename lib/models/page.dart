import 'dart:convert';

import 'package:dresscode/models/serializable.dart';

class Page<T extends Serializable> extends Serializable {
  final List<T> content;
  final int number;
  final int size;
  final int totalElements;
  final int totalPages;

  Page({
    required this.content,
    required this.number,
    required this.size,
    required this.totalElements,
    required this.totalPages,
  });

  @override
  Page.fromMap(final Map<String, dynamic> map)
      : content = map['content'] as List<T>,
        number = map['number'] as int,
        size = map['size'] as int,
        totalElements = map['totalElements'] as int,
        totalPages = map['totalPages'] as int;

  @override
  factory Page.fromJson(final String json) {
    final Map<String, dynamic> pageData = jsonDecode(json);
    return Page<T>(
      content: pageData['content'] as List<T>,
      number: pageData['number'] as int,
      size: pageData['size'] as int,
      totalElements: pageData['totalElements'] as int,
      totalPages: pageData['totalPages'] as int,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'content': content,
        'number': number,
        'size': size,
        'totalElements': totalElements,
        'totalPages': totalPages,
      };
}
