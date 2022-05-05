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
  try {
    await AuthService().getCurrentUser(token);
  } on Exception {
    // Nothing because we just wanted to load the user if there was one
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initDatabase();
  configureLogger();
  await TokenStorage.saveToken(
    'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJvbGFiaWplZEBnbWFpbC5jb20iLCJleHAiOjE2NTQzMzM2MzIsImlhdCI6MTY1MTc0MTYzMn0.OakUIxCMkL2qX0tAIri5LarsnKIw15uNFzHwEiShXME',
  );
  await initAuth();
  runApp(const App());
}
