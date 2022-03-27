import 'dart:convert';

import 'package:dresscode/models/image.dart';
import 'package:dresscode/models/serializable.dart';

import 'category.dart';

class Product extends Serializable {
  final String? code;
  final String name;
  final String description;
  final int price;
  final Category? category;
  final List<Image>? images;

  Product({
    this.code,
    required this.name,
    required this.description,
    required this.price,
    this.category,
    this.images,
  });

  @override
  Product.fromMap(final Map<String, dynamic> map)
      : code = map['code'] as String?,
        name = map['name'] as String,
        description = map['description'] as String,
        price = map['price'] as int,
        category = ((map['category'] as Map<String, dynamic>?) == null)
            ? null
            : Category.fromMap(map['category'] as Map<String, dynamic>),
        images = ((map['images'] as List<dynamic>?) == null)
            ? null
            : (map['images'] as List<dynamic>)
                .map((e) => Image.fromMap(e as Map<String, dynamic>))
                .toList();

  @override
  factory Product.fromJson(final String json) {
    return Product.fromMap(jsonDecode(json));
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'description': description,
      'price': price,
      'category': category?.toMap(),
      'images': images?.map((e) => e.toMap()).toList(),
    };
  }
}
