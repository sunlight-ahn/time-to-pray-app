import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_to_pray_app/components/getx_listener.dart';
import 'package:time_to_pray_app/controllers/authentication_controller.dart';
import 'package:time_to_pray_app/controllers/data_load.controller.dart';
import 'package:time_to_pray_app/controllers/pray_search_controller.dart';
import 'package:time_to_pray_app/controllers/splash_controller.dart';
import 'package:time_to_pray_app/models/enum/step_type.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF53B175),
      body: Center(
        child: GetxListener<bool>(
          listen: (bool isLogined) {
            if (isLogined) {
              Get.offNamed('/home');
            } else {
              Get.offNamed('/login');
            }
          },
          stream: Get.find<DataLoadController>()
              .isDataLoad, //Get.find<AuthenticationController>().isLogined,
          child: GetxListener<bool>(
            listen: (bool value) {
              if (value) {
                controller.loadStep(StepType.authCheck);
              }
            },
            stream: Get.find<DataLoadController>().isDataLoad,
            child: GetxListener<StepType>(
              initCall: () {
                controller.loadStep(StepType.dataLoad);
              },
              listen: (StepType? value) {
                if (value == null) return;
                switch (value) {
                  case StepType.init:
                  case StepType.dataLoad:
                    print('dataLoad..');
                    Get.find<DataLoadController>().loadData();
                    break;
                  case StepType.authCheck:
                    print('authCheck...');
                    //Get.find<AuthenticationController>().authCheck();
                    break;
                }
              },
              stream: controller.loadStep,
              // child: Obx(
              //   () {
              //     return Text(
              //       '${controller.loadStep.value.name}중 입니다.',
              //       style: const TextStyle(color: Colors.white),
              //     );
              //   },
              // ),
              child: _SplashView(),
            ),
          ),
        ),
      ),
    );
  }
}

class _SplashView extends GetView<SplashController> {
  const _SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: Image.asset(
                  'assets/images/book.png',
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '모두의 가톨릭 기도서',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Gilroy-Medium',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// child: GetxListener<StepType>(
        //   initCall: () {
        //     controller.loadStep(StepType.dataLoad);
        //   },
        //   listen: (StepType? value) {
        //     if (value == null) return;
        //     switch (value) {
        //       case StepType.init:
        //       case StepType.dataLoad:
        //         print('dataLoad..');
        //         Get.find<DataLoadController>().loadData();
        //         break;
        //       case StepType.authCheck:
        //         print('authCheck..');
        //         break;
        //     }
        //     if (Get.find<DataLoadController>().isDataLoad.value) {
        //       print('go Home......');
        //       Get.offNamed('/home');
        //     }
        //   },
        //   stream: controller.loadStep,
        //   child: Obx(() {
        //     return Text(
        //       "${controller.loadStep.value.name}중입니다.",
        //       style: const TextStyle(color: Colors.white),
        //     );
        //   }),
        // ),
        // child: Obx(
        //   () => Text(
        //     "${controller.loadStep.value.name}로딩중입니다.",
        //     style: const TextStyle(color: Colors.white),
        //   ),
        // ),
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Image.asset(
        //       'assets/images/book.png', // 이미지 경로 확인 필요
        //       width: 150,
        //       height: 150,
        //     ),
        //     //const SizedBox(height: 10),
        //     const Text(
        //       '모두의 가톨릭 기도서',
        //       textAlign: TextAlign.center,
        //       style: TextStyle(
        //         color: Colors.white,
        //         fontFamily: 'Gilroy-Medium',
        //         fontSize: 16,
        //         fontWeight: FontWeight.w400,
        //         letterSpacing: 3,
        //       ),
        //     ),
        //     const SizedBox(height: 15),
        //   ],
        // ),

// import 'package:flutter/material.dart';

// class SplashPage extends StatefulWidget {
//   const SplashPage({super.key});

//   @override
//   State<SplashPage> createState() => _SplashPageState();
// }

// class _SplashPageState extends State<SplashPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 414,
//       height: 896,
//       clipBehavior: Clip.antiAlias,
//       decoration: BoxDecoration(color: const Color(0xFF53B175)),
//       child: Stack(
//         children: [
//           Positioned(
//             left: 133,
//             top: 859,
//             child: Opacity(
//               opacity: 0.10,
//               child: Container(
//                 width: 148,
//                 height: 37,
//                 child: Stack(
//                   children: [
//                     Positioned(
//                       left: 7,
//                       top: 24,
//                       child: Container(
//                         width: 134,
//                         height: 5,
//                         decoration: ShapeDecoration(
//                           color: Colors.black,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(100),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             left: 0,
//             top: 0,
//             child: Container(
//               width: 414,
//               height: 98.26,
//               child: Stack(
//                 children: [
//                   Positioned(
//                     left: 0,
//                     top: 0,
//                     child: Container(
//                       width: 414,
//                       height: 98.26,
//                       clipBehavior: Clip.antiAlias,
//                       decoration: BoxDecoration(),
//                       child: Stack(
//                         children: [
//                           Positioned(
//                             left: 0,
//                             top: 5,
//                             child: Container(
//                               width: 414,
//                               height: 44,
//                               child: Stack(
//                                 children: [
//                                   Positioned(
//                                     left: 375,
//                                     top: 17.33,
//                                     child: Opacity(
//                                       opacity: 0.35,
//                                       child: Container(
//                                         width: 22,
//                                         height: 11.33,
//                                         decoration: ShapeDecoration(
//                                           shape: RoundedRectangleBorder(
//                                             side: BorderSide(
//                                                 width: 1, color: Colors.white),
//                                             borderRadius:
//                                                 BorderRadius.circular(2.67),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Positioned(
//                                     left: 377,
//                                     top: 19.33,
//                                     child: Container(
//                                       width: 18,
//                                       height: 7.33,
//                                       decoration: ShapeDecoration(
//                                         color: Colors.white,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(1.33),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             left: 108.35,
//             top: 464.30,
//             child: Text(
//               '모두의 가톨릭 기도서',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 14,
//                 fontFamily: 'Gilroy-Medium',
//                 fontWeight: FontWeight.w400,
//                 height: 1.29,
//                 letterSpacing: 5.50,
//               ),
//             ),
//           ),

//         ],
//       ),
//     );
//   }
// }
