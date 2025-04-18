import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/prayer.dart';

class PrayRepository {
  Database? _db;

  Future<void> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'prayers.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE prayers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT NOT NULL
          )
        ''');

        // 초기 더미 데이터 삽입
        await db.insert('prayers', {
          'title': '하느님 감사합니다',
          'content': '오늘 하루도 주심에 감사합니다.',
        });
        await db.insert('prayers', {
          'title': '평화를 위한 기도',
          'content': '세상에 평화를 주소서.',
        });
        await db.insert('prayers', {
          'title': '묵주 기도',
          'content': '성모님과 함께 드리는 기도입니다.',
        });
      },
    );
  }

  Future<List<Prayer>> searchPrayers(String keyword) async {
    if (_db == null) {
      await initDB();
    }

    final result = await _db!.query(
      'prayers',
      where: 'title LIKE ?',
      whereArgs: ['%$keyword%'],
    );

    return result.map((e) => Prayer.fromMap(e)).toList();
  }

  Future<void> close() async {
    await _db?.close();
  }
}
