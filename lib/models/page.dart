import 'dart:convert';

import 'package:dresscode/models/serializable.dart';

class Page<T extends Serializable> extends Serializable {
  final List<T> content;
  final int number;
  final int size;
  final int totalElements;
  final int totalPages;

  const Page({
    required this.content,
    required this.number,
    required this.size,
    required this.totalElements,
    required this.totalPages,
  });

  @override
  Page.fromMap(final Map<String, dynamic> map)
      : content = (map['content'] as List)
            .map((e) =>
                SerializableFactory.fromMap<T>(e as Map<String, dynamic>))
            .toList(growable: false),
        number = map['number'] as int,
        size = map['size'] as int,
        totalElements = map['totalElements'] as int,
        totalPages = map['totalPages'] as int;

  @override
  factory Page.fromJson(final String json) {
    final Map<String, dynamic> pageData = jsonDecode(json);
    return Page<T>.fromMap(pageData);
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
