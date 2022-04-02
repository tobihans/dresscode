import 'package:dresscode/utils/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:dresscode/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  await TokenStorage.saveToken('rrr');
  Logger.root.info('token: ${await TokenStorage.getToken()}');
  TokenStorage.hasToken().then((hasToken) {
    Logger.root.info('has token: $hasToken');
  });
  runApp(const App());
}
