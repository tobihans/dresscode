import 'dart:convert';

import 'package:dresscode/models/category.dart';
import 'package:dresscode/models/comment.dart';
import 'package:dresscode/models/image.dart';
import 'package:dresscode/models/notification.dart';
import 'package:dresscode/models/product.dart';
import 'package:dresscode/models/user.dart';

/// Base class for all our models
abstract class Serializable {
  const Serializable();

  Serializable.fromMap(final Map<String, dynamic> map);

  factory Serializable.fromJson(final String json) {
    throw UnimplementedError('Must be overridden in child classes');
  }

  Map<String, dynamic> toMap();

  String toJson() => jsonEncode(toMap());
}

/// Factory to help (de)serialization while keeping (strong) typing
/// We don't have the choice because it is not possible to use reflection/introspection
class SerializableFactory {
  static final Map<Type, Function> _serializableFactories = {
    Category: (final Map<String, dynamic> map) => Category.fromMap(map),
    Product: (final Map<String, dynamic> map) => Product.fromMap(map),
    Image: (final Map<String, dynamic> map) => Image.fromMap(map),
    User: (final Map<String, dynamic> map) => User.fromMap(map),
    Comment: (final Map<String, dynamic> map) => Comment.fromMap(map),
    Notification: (final Map<String, dynamic> map) => Notification.fromMap(map),
  };

  static T fromMap<T extends Serializable>(final Map<String, dynamic> map) {
    return _serializableFactories[T]!(map);
  }
}
