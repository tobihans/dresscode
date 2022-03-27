import 'dart:convert';

import 'package:dresscode/models/serializable.dart';
import 'package:dresscode/models/user.dart';

class Comment extends Serializable {
  final String? code;
  final String comment;
  final User? user;

  Comment({
    this.code,
    required this.comment,
    this.user,
  });

  @override
  Comment.fromMap(final Map<String, dynamic> map)
      : code = map['code'] as String?,
        comment = map['comment'] as String,
        user = ((map['user'] as Map<String, dynamic>?) == null)
            ? null
            : User.fromMap(map['user'] as Map<String, dynamic>);

  @override
  factory Comment.fromJson(final String json) {
    final Map<String, dynamic> commentData = jsonDecode(json);
    return Comment.fromMap(commentData);
  }

  @override
  Map<String, dynamic> toMap() => {
        'code': code,
        'comment': comment,
        'user': user?.toMap(),
      };
}
