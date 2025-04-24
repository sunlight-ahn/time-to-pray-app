import 'package:get/get.dart';

class DataLoadController extends GetxController {
  RxBool isDataLoad = false.obs;

  void loadData() async {
    await Future.delayed(const Duration(milliseconds: 5000));
    isDataLoad(true);
    print('loadData..................');
  }
}
