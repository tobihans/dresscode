import 'dart:convert';

import 'package:dresscode/models/serializable.dart';

class Notification extends Serializable {
  final int? id;
  final String title;
  final String content;
  final String userCode;

  const Notification({
    this.id,
    required this.title,
    required this.content,
    required this.userCode,
  });

  @override
  Notification.fromMap(final Map<String, dynamic> map)
      : id = map['id'] as int?,
        title = map['title'] as String,
        content = map['content'] as String,
        userCode = map['userCode'] as String;

  @override
  factory Notification.fromJson(final String json) {
    final Map<String, dynamic> notificationData = jsonDecode(json);
    return Notification(
      id: notificationData['id'] as int?,
      title: notificationData['title'] as String,
      content: notificationData['content'] as String,
      userCode: notificationData['userCode'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'content': content,
        'userCode': userCode,
      };
}
