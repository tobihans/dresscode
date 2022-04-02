import 'dart:convert';

import 'package:dresscode/requests/body_request.dart';

class CommentRequest extends BodyRequest {
  final String comment;
  final String productCode;

  const CommentRequest({
    required this.comment,
    required this.productCode,
  });

  @override
  String toJson() {
    final Map<String, String> commentData = {
      'comment': comment,
      'productCode': productCode,
    };
    return jsonEncode(commentData);
  }
}
