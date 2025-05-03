import 'package:flutter_test/flutter_test.dart';
import 'package:time_to_pray_app/models/prayer.dart';
import 'package:time_to_pray_app/repository/pray_repository.dart';
import 'package:logger/logger.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // ★ 추가
import 'package:time_to_pray_app/models/dummy_prayer.dart';

void main() {
  sqfliteFfiInit(); // ★ 필수 초기화
  databaseFactory = databaseFactoryFfi; // ★ 필수 설정

  late PrayRepository repository;
  final logger = Logger();

  setUp(() async {
    repository = PrayRepository();
    await repository.initDB(); //DB 연결
    await repository.clearPrayers(); //데이터 초기화
    print('setUp - 각 테스트 실행 전');
  });

  tearDown(() async {
    await repository.clearPrayers();
    await repository.close();
    print('tearDown - 각 테스트 실행 후');
  });

  test('더미데이터 초기화 후 결과는 비어있어야한다.', () async {
    List<Prayer> results = await repository.getPrayers();
    expect(results, isEmpty);
    print('getPrayers result : $results');
  });

  test('더미데이터 등록 후 결과값이 있어야 한다.', () async {
    await repository.initData(); // await 추가 (비동기)
    List<Prayer> results = await repository.getPrayers();
    expect(results, isNotEmpty);
    //expect(results.first.title, contains('주님'));
  });

  test('전체 기도문을 SqlLite로 조회시 리스트가 존재한다.', () async {
    await repository.initData(); // await 추가 (비동기)
    List<Prayer> results = await repository.getPrayers();
    expect(results.isNotEmpty, isTrue);
    if (results.isNotEmpty) {
      // 📝 Logger 결과 출력
      for (var prayer in results) {
        logger.i(prayer);
      }
      ////logger.i('기도문: ID=${prayer.id}, Title=${prayer.title}, Contents=${prayer.content}, IsFavorite=${prayer.isFavorite}');
    }
  });

  test('기도문 저장 테스트', () async {
    await repository.insertPrayer(Prayer(
      id: 0,
      title: '테스트 기도',
      content: '테스트 기도 내용입니다.',
      isFavorite: false,
      prayType: '테스트',
      prayKey: 'test_prayer',
      version: '1.0',
      registerDate: DateTime.now(),
      modifiedDate: DateTime.now(),
    ));

    final prayers = await repository.getPrayers();
    expect(prayers.length, equals(1));
    expect(prayers.first.title, equals('테스트 기도'));
  });

  test('searchPrayers should return matching prayers', () async {
    await repository.initData();
    final prayers = await repository.getPrayersByPrayKey('주님의기도');
    expect(prayers.length, 1);
    expect(prayers[0].title, '주님의 기도');
  });
}
