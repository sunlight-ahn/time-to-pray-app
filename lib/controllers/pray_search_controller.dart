// lib/controllers/pray_search_controller.dart
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../models/prayer.dart';
import '../repository/test_pray_repository.dart';

class PraySearchController extends GetxController {
  final RxList<Prayer> results = <Prayer>[].obs;
  final _repository = TestPrayRepository();
  final Logger _logger = Logger();

  final RxnInt focusedPrayerId = RxnInt(); // 🔍 포커스될 기도문 ID

  Future<void> search(String keyword) async {
    _logger.i('검색 키워드: $keyword');
    results.value = await _repository.searchPrayers(keyword);
  }

  void setFocusedPrayerId(int id) {
    _logger.i('포커스 ID 설정: $id');
    focusedPrayerId.value = id;
  }

  void clearFocusedPrayerId() {
    focusedPrayerId.value = null;
  }
}
