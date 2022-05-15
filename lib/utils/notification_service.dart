import 'package:dresscode/models/notification.dart';
import 'package:sqflite/sqflite.dart';

class NotificationService {
  static const String _tableName = 'notifications';
  static const String _dbFile = 'dresscode.db';
  static Database? _database;

  static Future<void> initDatabase() async {
    _database ??= await openDatabase(
      _join(await getDatabasesPath(), _dbFile),
      version: 1,
      onCreate: (Database db, _) async {
        await db.execute(
          'CREATE TABLE $_tableName (id INTEGER PRIMARY KEY, title TEXT, content TEXT,userCode TEXT);',
        );
        return db.execute(
          'CREATE INDEX user_code_idx ON $_tableName (userCode)',
        );
      },
    );
  }

  static Future<void> insert(Notification notification) async {
    await _database?.insert(
      _tableName,
      notification.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Notification>> getAllNotifications(String userCode) async {
    final data = await _database?.query(
      _tableName,
      orderBy: 'id',
      where: 'userCode = ?',
      whereArgs: [userCode],
    );
    return data?.map(Notification.fromMap).toList() ?? [];
  }

  static Future<void> deleteNotification(Notification notification) async {
    await _database?.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [notification.id],
    );
  }

  static String _join(String path1, String path2) {
    if (path1.endsWith('/')) {
      return '$path1$path2';
    }
    return '$path1/$path2';
  }
}
