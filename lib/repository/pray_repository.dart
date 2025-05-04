import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:logger/logger.dart';
import '../models/prayer.dart';
import '../models/dummy_prayer.dart';

class PrayRepository {
  Database? _db;
  final logger = Logger();

  // SQLite의 정수값을 bool로 변환
  bool _toBool(int value) => value == 1;

  // bool을 SQLite의 정수값으로 변환
  int _toInt(bool value) => value ? 1 : 0;

  Future<List<Prayer>> getPrayers() async {
    if (_db == null) {
      await initDB();
    }
    //logger.i('DB 경로: ${await getDatabasesPath()}');
    final result = await _db!.query('prayers', where: 'isShow = 1');
    return result
        .map((e) => Prayer.fromMap({
              ...e,
              'isFavorite': _toBool(e['isFavorite'] as int),
              'isShow': _toBool(e['isShow'] as int),
            }))
        .toList();
  }

  //기도문 키로 조회
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
    return result
        .map((e) => Prayer.fromMap({
              ...e,
              'isFavorite': _toBool(e['isFavorite'] as int),
              'isShow': _toBool(e['isShow'] as int),
            }))
        .toList();
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
      where: 'title LIKE ? AND isShow = 1',
      whereArgs: ['%$keyword%'],
    );
    if (result.isEmpty) {
      logger.i('prayers list is null');
    } else {
      for (var prayer in result) {
        logger.i(prayer);
      }
    }
    return result
        .map((e) => Prayer.fromMap({
              ...e,
              'isFavorite': _toBool(e['isFavorite'] as int),
              'isShow': _toBool(e['isShow'] as int),
            }))
        .toList();
  }

  //즐겨찾기 기도문 조회
  Future<List<Prayer>> getFavoritePrayers() async {
    if (_db == null) {
      await initDB();
    }
    final result = await _db!.query(
      'prayers',
      where: 'isFavorite = ? AND isShow = 1',
      whereArgs: [1],
    );
    return result
        .map((e) => Prayer.fromMap({
              ...e,
              'isFavorite': _toBool(e['isFavorite'] as int),
              'isShow': _toBool(e['isShow'] as int),
            }))
        .toList();
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

  //전체 기도문 삭제
  Future<void> clearPrayers() async {
    if (_db == null) {
      await initDB();
    }
    try {
      // 테이블 존재 여부 확인
      final tables = await _db!.query('sqlite_master',
          where: 'type = ? AND name = ?', whereArgs: ['table', 'prayers']);

      if (tables.isNotEmpty) {
        await _db!.delete('prayers');
        logger.i('prayers 테이블 데이터가 삭제되었습니다.');
      } else {
        logger.i('prayers 테이블이 존재하지 않습니다.');
      }
    } catch (e) {
      logger.e('prayers 테이블 삭제 중 오류 발생: $e');
    }
  }

  //기도문 저장
  Future<void> insertPrayer(Prayer prayer) async {
    if (_db == null) {
      await initDB();
    }
    await _db!.insert(
      'prayers',
      {
        'title': prayer.title,
        'content': prayer.content,
        'isFavorite':
            _toInt(prayer.isFavorite), // bool -> int (true -> 1, false -> 0)
        'isShow': _toInt(prayer.isShow), // bool -> int (true -> 1, false -> 0)
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

  String _getCreateTableSQL() {
    return '''
      CREATE TABLE prayers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        isFavorite BOOLEAN NOT NULL,
        isShow BOOLEAN NOT NULL,
        prayType TEXT,
        prayKey TEXT UNIQUE,
        version TEXT,
        registerDate TEXT NOT NULL,
        modifiedDate TEXT NOT NULL
      )
    ''';
  }

  //데이터베이스 초기화
  Future<void> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'prayers.db');

    _db = await openDatabase(
      path,
      version: 1,
    );
  }

  // 데이터베이스 초기화 (테이블 생성 포함)
  Future<void> initialize() async {
    if (_db == null) {
      await initDB();
    }
    await dropTable();
    await createTable();
  }

  // 테이블 생성
  Future<void> createTable() async {
    if (_db == null) {
      await initDB();
    }
    await _db!.execute(_getCreateTableSQL());
  }

  // 테이블 삭제
  Future<void> dropTable() async {
    if (_db == null) {
      await initDB();
    }
    await _db!.execute('DROP TABLE IF EXISTS prayers');
  }

  //기도문 데이터 초기화
  Future<void> initData() async {
    if (_db == null) {
      await initDB();
    }

    for (final prayerData in DummyPrayer.dummyPrayers) {
      // Prayer 모델로 변환하여 저장
      final prayer = Prayer(
        id: 0,
        title: prayerData['title'] as String,
        content: prayerData['content'] as String,
        isFavorite: prayerData['isFavorite'] as bool,
        isShow: prayerData['isShow'] as bool,
        prayType: prayerData['prayType'] as String,
        prayKey: prayerData['prayKey'] as String,
        version: prayerData['version'] as String,
        registerDate: DateTime.parse(prayerData['registerDate'] as String),
        modifiedDate: DateTime.parse(prayerData['modifiedDate'] as String),
      );
      logger.i('initData prayer : $prayer');
      await insertPrayer(prayer);
    }
  }
} //-- root end
