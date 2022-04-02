import 'package:dresscode/models/notification.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotificationService {
  static const String _tableName = 'notifications';
  static const String _dbFile = 'dresscode.db';
  static Database? _database;
  static final Logger _logger = Logger('$NotificationService');

  static Future<void> initDatabase() async {
    _logger.info('Initializing database');
    _database ??= await openDatabase(
      join(await getDatabasesPath(), _dbFile),
      version: 1,
      onCreate: (Database db, int version) async {
        return db.execute(
          'CREATE TABLE $_tableName (id INTEGER PRIMARY KEY, title TEXT, content TEXT)',
        );
      },
    );
  }

  static Future<void> insert(Notification notification) async {
    _logger.info('Inserting into db Notification : ${notification.toJson()}');
    await _database?.insert(
      _tableName,
      notification.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Notification>> getAllNotifications() async {
    _logger.info('Getting all notifications');
    final data = await _database?.query(_tableName, orderBy: 'id');
    return data?.map(Notification.fromMap).toList() ?? [];
  }

  static Future<void> deleteNotification(Notification notification) async {
    _logger.info('Deleting notification : ${notification.toJson()}');
    await _database?.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [notification.id],
    );
  }
}
