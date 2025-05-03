import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:logger/logger.dart';
import '../models/prayer.dart';
import '../models/dummy_prayer.dart';

class PrayRepository {
  Database? _db;
  final logger = Logger();

  String _getCreateTableSQL() {
    return '''
      CREATE TABLE prayers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        isFavorite BOOLEAN NOT NULL,
        prayType TEXT,
        prayKey TEXT UNIQUE,
        version TEXT,
        registerDate TEXT NOT NULL,
        modifiedDate TEXT NOT NULL
      )
    ''';
  }

  Future<void> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'prayers.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(_getCreateTableSQL());
      },
      onOpen: (Database db) async {
        try {
          // 기존 테이블의 컬럼 정보 조회
          final tableInfo = await db.rawQuery('PRAGMA table_info(prayers)');

          // 테이블이 없는 경우
          if (tableInfo.isEmpty) {
            await db.execute(_getCreateTableSQL());
            return;
          }

          // 현재 필요한 컬럼 목록
          final requiredColumns = [
            'id',
            'title',
            'content',
            'isFavorite',
            'prayType',
            'prayKey',
            'version',
            'registerDate',
            'modifiedDate'
          ];

          // 기존 테이블의 컬럼 이름 목록
          final existingColumns =
              tableInfo.map((col) => col['name'] as String).toList();

          // 컬럼이 다르면 테이블 삭제 후 재생성
          if (existingColumns.length != requiredColumns.length ||
              !requiredColumns.every((col) => existingColumns.contains(col))) {
            await db.execute('DROP TABLE IF EXISTS prayers');
            await db.execute(_getCreateTableSQL());
            logger.i('테이블 재생성......................................');
          }
        } catch (e) {
          // 테이블이 없는 경우 예외 발생
          await db.execute(_getCreateTableSQL());
        }
      },
    );
  }

  // SQLite의 정수값을 bool로 변환
  bool _toBool(int value) => value == 1;

  // bool을 SQLite의 정수값으로 변환
  int _toInt(bool value) => value ? 1 : 0;

  Future<List<Prayer>> getPrayers() async {
    if (_db == null) {
      await initDB();
    }
    //logger.i('DB 경로: ${await getDatabasesPath()}');
    final result = await _db!.query('prayers');
    return result
        .map((e) => Prayer.fromMap({
              ...e,
              'isFavorite': _toBool(e['isFavorite'] as int),
            }))
        .toList();
  }

  Future<List<Prayer>> getPrayersByPrayKey(String prayKey) async {
    if (_db == null) {
      await initDB();
    }
    //logger.i('DB 경로: ${await getDatabasesPath()}');
    final result = await _db!.query(
      'prayers',
      where: 'prayKey = ?',
      whereArgs: [prayKey],
    );

    return result.map((e) => Prayer.fromMap(e)).toList();
  }

  //기도문 조회
  Future<List<Prayer>> searchPrayers(String keyword) async {
    if (_db == null) {
      await initDB();
    }
    //logger.i('DB 경로: ${await getDatabasesPath()}');
    logger.i('searchPrayers, keyword: $keyword');
    final result = await _db!.query(
      'prayers',
      where: 'title LIKE ?',
      whereArgs: ['%$keyword%'],
    );
    if (result.isEmpty) {
      logger.i('prayers list is null');
    } else {
      for (var prayer in result) {
        logger.i(prayer);
      }
    }
    return result.map((e) => Prayer.fromMap(e)).toList();
  }

  //즐겨찾기 기도문 조회
  Future<List<Prayer>> getFavoritePrayers() async {
    if (_db == null) {
      await initDB();
    }
    final result = await _db!.query(
      'prayers',
      where: 'isFavorite = ?',
      whereArgs: [1],
      //whereArgs: [_toInt(true)],
    );

    return result.map((e) => Prayer.fromMap(e)).toList();
  }

  //즐겨찾기 상태 수정
  Future<void> updateFavoriteStatus(int id, bool isFavorite) async {
    if (_db == null) {
      await initDB();
    }
    await _db!.update(
      'prayers',
      {'isFavorite': _toInt(isFavorite)},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertPrayer(Prayer prayer) async {
    if (_db == null) {
      await initDB();
    }
    await _db!.insert(
      'prayers',
      {
        'title': prayer.title,
        'content': prayer.content,
        'isFavorite': _toInt(prayer.isFavorite),
        'prayType': prayer.prayType,
        'prayKey': prayer.prayKey,
        'version': prayer.version,
        'registerDate': prayer.registerDate.toIso8601String(),
        'modifiedDate': prayer.modifiedDate.toIso8601String(),
      },
    );
  }

  Future<void> close() async {
    await _db?.close();
  }

  Future<void> clearPrayers() async {
    if (_db == null) {
      await initDB();
    }

    await _db!.delete('prayers');
  }

  Future<void> initData() async {
    if (_db == null) {
      await initDB();
    }
    await clearPrayers();

    for (final prayerData in DummyPrayer.dummyPrayers) {
      final existing = await _db!.query(
        'prayers',
        where: 'title = ?',
        whereArgs: [prayerData['title']],
      );

      if (existing.isEmpty) {
        // Prayer 모델로 변환하여 저장
        final prayer = Prayer(
          id: 0,
          title: prayerData['title'] as String,
          content: prayerData['content'] as String,
          isFavorite: prayerData['isFavorite'] == 1,
          prayType: prayerData['prayType'] as String,
          prayKey: prayerData['prayKey'] as String,
          version: prayerData['version'] as String,
          registerDate: DateTime.parse(prayerData['registerDate'] as String),
          modifiedDate: DateTime.parse(prayerData['modifiedDate'] as String),
        );
        await insertPrayer(prayer);
      }
    }
  }
} //-- root end
