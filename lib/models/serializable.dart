import 'dart:convert';

import 'package:dresscode/models/category.dart';
import 'package:dresscode/models/comment.dart';
import 'package:dresscode/models/image.dart';
import 'package:dresscode/models/product.dart';
import 'package:dresscode/models/user.dart';

abstract class Serializable {
  Serializable();
  Serializable.fromMap(final Map<String,dynamic> map);
  factory Serializable.fromJson(final String json) {
    throw UnimplementedError('Must be overridden in child classes');
  }
  Map<String,dynamic> toMap();
  String toJson() => jsonEncode(toMap());
}

class SerializableFactory {
  static final Map<Type,Function> _serializableFactories = <Type,Function> {
    Category: (final Map<String,dynamic> map) => Category.fromMap(map),
    Product: (final Map<String,dynamic> map) => Product.fromMap(map),
    Image: (final Map<String,dynamic> map) => Image.fromMap(map),
    User: (final Map<String,dynamic> map) => User.fromMap(map),
    Comment: (final Map<String,dynamic> map) => Comment.fromMap(map),
  };
  
  static T fromMap<T extends Serializable>(final Map<String,dynamic> map) {
    return _serializableFactories[T]!(map);
  }
}
