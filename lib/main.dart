import 'package:dresscode/api/services/auth_service.dart';
import 'package:dresscode/utils/notification_service.dart';
import 'package:dresscode/utils/token_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
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
  Stripe.publishableKey =
      "pk_test_51Kv24qCChyL9hOISBZ842XIzYLi5KcVPk5W2Lf8z54zFyW2Tu7XkMcU2B7p9O76q9oF16ZWlX8q6AhajPJjAlEpq00mzJknZsu";
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initDatabase();
  configureLogger();
  await initAuth();

  runApp(const App());
}
