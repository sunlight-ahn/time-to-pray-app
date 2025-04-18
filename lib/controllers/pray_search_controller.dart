// lib/controllers/pray_search_controller.dart

import 'package:get/get.dart';
import '../models/prayer.dart';
import '../repository/test_pray_repository.dart';

class PraySearchController extends GetxController {
  final RxList<Prayer> results = <Prayer>[].obs;

  final _repository = TestPrayRepository();

  Future<void> search(String keyword) async {
    results.value = await _repository.searchPrayers(keyword);
  }
}
