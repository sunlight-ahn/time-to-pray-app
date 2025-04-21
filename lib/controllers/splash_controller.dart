import 'package:get/get.dart';
import 'package:time_to_pray_app/models/enum/step_type.dart';

class SplashController extends GetxController {
  Rx<StepType> loadStep = StepType.dataLoad.obs;
  void changeStep(StepType type) {
    loadStep(type);
  }
}
