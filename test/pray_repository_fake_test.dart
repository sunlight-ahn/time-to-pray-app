import 'package:flutter_test/flutter_test.dart';
import 'package:time_to_pray_app/models/prayer.dart';
import 'package:time_to_pray_app/repository/test_pray_repository.dart';

void main() {
  late TestPrayRepository repository;

  setUp(() {
    repository = TestPrayRepository();
    //await repository.initDB();
  });

  test('keyword로 기도문 검색', () async {
    List<Prayer> results = await repository.searchPrayers('주님');
    expect(results.isNotEmpty, true);
    expect(results.first.title, contains('주님'));
  });

  // test('없는 키워드 검색 결과 없음', () async {
  //   List<Prayer> results = await repository.searchPrayers('없는제목');
  //   expect(results.isEmpty, true);
  // });
}
