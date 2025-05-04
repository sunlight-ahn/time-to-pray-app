import 'package:get/get.dart';
import 'package:time_to_pray_app/models/enum/step_type.dart';
import 'pray_rosary_controller.dart';

class SplashController extends GetxController {
  Rx<StepType> loadStep = StepType.dataLoad.obs;

  @override
  void onInit() {
    super.onInit();
    Get.put(PrayRosaryController());
  }

  void changeStep(StepType type) {
    loadStep(type);
  }
}
