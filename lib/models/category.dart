import 'dart:convert';

import 'package:dresscode/models/serializable.dart';

class Category extends Serializable {
  final String? code;
  final String name;
  final String description;

  Category({this.code, required this.name, required this.description});

  @override
  Category.fromMap(final Map<String, dynamic> map)
      : code = map['code'] as String?,
        name = map['name'] as String,
        description = map['description'] as String;

  @override
  factory Category.fromJson(String json) {
    final Map<String, dynamic> categoryData = jsonDecode(json);
    return Category(
      code: categoryData['code'] as String?,
      name: categoryData['name'] as String,
      description: categoryData['description'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'code': code,
        'name': name,
        'description': description,
      };
}
