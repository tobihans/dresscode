import 'package:dresscode/models/notification.dart' as notification;
import 'package:dresscode/utils/notification_service.dart';
import 'package:dresscode/utils/token_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:dresscode/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  await TokenStorage.saveToken('eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJvbGFAZ21haWwuY29tIiwiZXhwIjoxNjUxNTIxOTM3LCJpYXQiOjE2NDg5Mjk5Mzd9.rQsTQh8n_kOuAm3KB3Ox_ZDM9PIS8NCSc-BbiiZay3Q');
  runApp(const App());
}
