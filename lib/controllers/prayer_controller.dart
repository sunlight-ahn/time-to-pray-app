import 'package:get/get.dart';
import '../models/prayer.dart';

class PrayerController extends GetxController {
  final Prayer prayer;
  late RxBool isFavorite;

  PrayerController({required this.prayer}) {
    isFavorite = prayer.isFavorite.obs;
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }
}
