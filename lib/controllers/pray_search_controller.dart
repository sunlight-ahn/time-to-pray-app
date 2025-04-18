// lib/controllers/pray_search_controller.dart

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../models/prayer.dart';
import '../repository/test_pray_repository.dart';

class PraySearchController extends GetxController {
  final RxList<Prayer> results = <Prayer>[].obs;

  final _repository = TestPrayRepository();
  final Logger _logger = Logger(); // 🔥 Logger 인스턴스 생성

  Future<void> search(String keyword) async {
    _logger.i('Searching prayers with keyword: $keyword'); // ℹ️ info 로그
    results.value = await _repository.searchPrayers(keyword);
  }
}
