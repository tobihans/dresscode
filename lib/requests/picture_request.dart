import 'dart:convert';

import 'package:dresscode/requests/body_request.dart';

class PictureRequest extends BodyRequest {
  final String image;

  const PictureRequest({
    required this.image,
  });

  @override
  String toJson() {
    final Map<String, String> pictureData = {
      'image': image,
    };
    return jsonEncode(pictureData);
  }
}
