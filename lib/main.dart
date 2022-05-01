import 'package:dresscode/api/services/auth_service.dart';
import 'package:dresscode/utils/notification_service.dart';
import 'package:dresscode/utils/token_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:dresscode/app.dart';

void configureLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    }
  });
}

Future<void> initAuth() async {
  final token = await TokenStorage.getToken();
  await AuthService().getCurrentUser(token);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initDatabase();
  configureLogger();
  await TokenStorage.saveToken(
    'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJvbGFAZ21haWwuY29tIiwiZXhwIjoxNjUxNTIxOTM3LCJpYXQiOjE2NDg5Mjk5Mzd9.rQsTQh8n_kOuAm3KB3Ox_ZDM9PIS8NCSc-BbiiZay3Q',
  );
  await initAuth();
  runApp(const App());
}
