import 'package:dresscode/api/services/auth_service.dart';
import 'package:dresscode/utils/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:logging/logging.dart';
import 'package:dresscode/app.dart';
import 'package:dresscode/.env.dart';

void configureLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    }
  });
}

/// Util method to load the user data and the token if existing
Future<void> initAuth() async {
  try {
    await AuthService.getUserFromTokenStorage();
  } catch (_) {}
}

Future<void> main() async {
  Stripe.publishableKey = stripePublishableKey;
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initDatabase();
  configureLogger();
  await initAuth();

  runApp(const App());
}
