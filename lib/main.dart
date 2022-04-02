import 'package:dresscode/models/notification.dart' as notification;
import 'package:dresscode/utils/notification_service.dart';
import 'package:dresscode/utils/token_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:dresscode/app.dart';

Future<void> main() async {
  await NotificationService.initDatabase();
  List.generate(10, (index) => index)
      .map(
        (e) => notification.Notification(
          title: 'Notification $e',
          content: 'This is the $e notification',
        ),
      )
      .forEach(
        (element) async => await NotificationService.insert(element),
      );

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    }
  });
  await TokenStorage.saveToken(
      'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJvbGFiaWplZEBnbWFpbC5jb20iLCJleHAiOjE2NDg4NDU0NjEsImlhdCI6MTY0ODgxNjY2MX0.NM95i_nqRGPuKkausJNZTfmBTrhM258M51F3eN5x5FM');
  runApp(const App());
}
