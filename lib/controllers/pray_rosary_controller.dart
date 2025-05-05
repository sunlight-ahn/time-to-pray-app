import 'package:get/get.dart';
import '../models/prayer.dart';
import '../repository/pray_repository.dart';

class PrayRosaryController extends GetxController {
  final PrayRepository _repository = PrayRepository();
  final Rx<Prayer?> currentPrayer = Rx<Prayer?>(null);
  final RxBool isLoading = false.obs;

  Future<void> loadPrayer(int prayerId) async {
    try {
      print('loadPrayer(), prayerId : $prayerId');
      isLoading.value = true;
      final prayers = await _repository.getPrayers();
      final prayer = prayers.firstWhere((p) => p.id == prayerId);
      currentPrayer.value = prayer;
    } catch (e) {
      Get.snackbar(
        '오류',
        '기도문을 불러오는데 실패했습니다.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<Prayer?> getPrayerByPrayKey(String prayKey) async {
    try {
      isLoading.value = true;
      final prayers = await _repository.getPrayersByPrayKey(prayKey);
      if (prayers.isNotEmpty) {
        currentPrayer.value = prayers.first;
        return prayers.first;
      } else {
        Get.snackbar(
          '오류',
          '기도문을 찾을 수 없습니다.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return null;
      }
    } catch (e) {
      Get.snackbar(
        '오류',
        '기도문을 불러오는데 실패했습니다.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
