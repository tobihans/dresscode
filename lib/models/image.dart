import 'dart:convert';

import 'package:dresscode/models/serializable.dart';

class Image extends Serializable {
  final String? code;
  final String url;

  Image({
    this.code,
    required this.url,
  });

  @override
  Image.fromMap(final Map<String, dynamic> map)
      : code = map['code'] as String?,
        url = map['url'] as String;

  @override
  factory Image.fromJson(final String json) {
    final Map<String, dynamic> imageData = jsonDecode(json);
    return Image(
      code: imageData['code'] as String?,
      url: imageData['url'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'code': code,
        'url': url,
      };
}
