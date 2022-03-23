import 'dart:convert';

abstract class Serializable {
  Serializable();
  Serializable.fromMap(final Map<String,dynamic> map);
  factory Serializable.fromJson(final String json) {
    throw UnimplementedError('Must be overridden in child classes');
  }
  Map<String,dynamic> toMap();
  String toJson() => jsonEncode(toMap());
}