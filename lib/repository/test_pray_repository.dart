import '../models/prayer.dart';

class TestPrayRepository {
  Future<List<Prayer>> searchPrayers(String keyword) async {
    final dummyData = [
      Prayer(id: 1, title: '하느님 감사합니다', content: '오늘 하루도 주심에 감사합니다.'),
      Prayer(id: 2, title: '평화를 위한 기도', content: '세상에 평화를 주소서.'),
      Prayer(id: 3, title: '묵주 기도', content: '성모님과 함께 드리는 기도입니다.'),
    ];

    return dummyData
        .where((prayer) => prayer.title.contains(keyword))
        .toList();
  }
}
