import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:logger/logger.dart';
import '../models/prayer.dart';

class PrayRepository {
  Database? _db;
  final logger = Logger();

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
            content TEXT NOT NULL,
            isFavorite BOOLEAN NOT NULL
          )
        ''');
      },
    );
  }

  Future<List<Prayer>> getPrayers() async {
    if (_db == null) {
      await initDB();
    }
    //logger.i('DB 경로: ${await getDatabasesPath()}');
    final result = await _db!.query(
      'prayers',
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
      where: 'isFavorite = 1',
    );
    if (result.isEmpty) {
      logger.i('favoite prayers list is null');
    } else {
      for (var prayer in result) {
        logger.i(prayer);
      }
    }
    return result.map((e) => Prayer.fromMap(e)).toList();
  }

  //즐겨찾기 상태 수정
  Future<void> updateFavoriteStatus(int id, bool isFavorite) async {
    if (_db == null) {
      await initDB();
    }
    await _db!.update(
      'prayers', // 테이블 이름
      {
        'isFavorite': isFavorite ? 1 : 0, // bool → int 변환
      },
      where: 'id = ?', // 업데이트할 조건
      whereArgs: [id], // 조건 값
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
        'isFavorite': prayer.isFavorite ? 1 : 0, // ✅ bool → int 변환
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
    await clearPrayers(); // ⭐ 데이터 싹 비우기

    // 더미 데이터 리스트
    final dummyPrayers = [
      {
        'title': '주님의 기도',
        'content': '하늘에 계신 우리 아버지,\n'
            '아버지의 이름이 거룩히 빛나시며\n'
            '아버지의 나라가 오시며\n'
            '아버지의 뜻이 하늘에서와 같이\n'
            '땅에서도 이루어지소서!\n\n'
            '오늘 저희에게 일용할 양식을 주시고\n'
            '저희에게 잘못한 이를 저희가 용서하오니\n'
            '저희 죄를 용서하시고\n'
            '저희를 유혹에 빠지지 않게 하시고\n'
            '악에서 구하소서.\n'
            '아멘.',
        'isFavorite': false,
      },
      {
        'title': '성모송',
        'content': '은총이 가득하신 마리아님, 기뻐하소서!\n'
            '주님께서 함께 계시니 여인 중에 복되시며\n'
            '태중의 아들 예수님 또한 복되시나이다.\n\n'
            '천주의 성모 마리아님,\n'
            '이제와 저희 죽을 때에\n'
            '저희 죄인을 위하여 빌어주소서.\n'
            '아멘.',
        'isFavorite': false,
      },
      {
        'title': '사도신경',
        'content': '전능하신 천주 성부\n'
            '천지의 창조주를 저는 믿나이다.\n'
            '그 외아들 우리 주 예수 그리스도님\n'
            '밑줄 부분에서 모두 깊은 절을 한다.\n'
            '성령으로 인하여 동정 마리아께 잉태되어 나시고\n'
            '본시오 빌라도 통치 아래서 고난을 받으시고\n'
            '십자가에 못 박혀 돌아가시고 묻히셨으며\n'
            '저승에 가시어 사흗날에 죽은 이들 가운데서 부활하시고\n'
            '하늘에 올라 전능하신 천주 성부 오른편에 앉으시며\n'
            '그리로부터 산 이와 죽은 이를 심판하러 오시리라 믿나이다.\n'
            '성령을 믿으며\n'
            '거룩하고 보편된 교회와 모든 성인의 통공을 믿으며\n'
            '죄의 용서와 육신의 부활을 믿으며\n'
            '영원한 삶을 믿나이다.\n'
            '아멘.',
        'isFavorite': true,
      },
      {
        'title': '영광송',
        'content': '밑줄 부분에서 고개를 숙이며\n'
            '영광이 성부와 성자와 성령께\n'
            '처음과 같이\n'
            '이제와 항상 영원히.\n'
            '아멘.',
        'isFavorite': true,
      },
    ];

    for (final prayer in dummyPrayers) {
      // 이미 같은 title이 존재하는지 확인
      final existing = await _db!.query(
        'prayers',
        where: 'title = ?',
        whereArgs: [prayer['title']],
      );

      if (existing.isEmpty) {
        // 없으면 삽입
        final prayerForInsert = {
          'title': prayer['title'],
          'content': prayer['content'],
          'isFavorite': (prayer['isFavorite'] == true) ? 1 : 0, // ⭐️ 변환
        };

        await _db!.insert('prayers', prayerForInsert);
      } else {
        // 있으면 삽입하지 않음
        print('이미 존재하는 기도문: ${prayer['title']}');
        break;
      }
    }
  }
} //-- root end
