import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:time_to_pray_app/app.dart';
import 'package:time_to_pray_app/controllers/authentication_controller.dart';
import 'package:time_to_pray_app/controllers/bottom_nav_controller.dart';
import 'package:time_to_pray_app/controllers/data_load.controller.dart';
import 'package:time_to_pray_app/controllers/splash_controller.dart';
import 'package:time_to_pray_app/firebase_options.dart';
import 'package:time_to_pray_app/root.dart';
import 'controllers/main_navigation_controller.dart';
import 'pages/home_page.dart';
import 'pages/search_page.dart';
import 'pages/pray_list_page.dart';

late SharedPreferences prefs;
void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Firebase SDK가 안드로이드와 ios의 네이티브 코드와 상호작용하기 위해서 설정.
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const TimeToPrayApp());
}

class TimeToPrayApp extends StatelessWidget {
  const TimeToPrayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '모두의 가톨릭 기도서',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF53B175),
        ), //Colors.orange
        useMaterial3: true,
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(MainNavigationController());
        Get.put(SplashController());
        Get.put(DataLoadController());
        Get.put(AuthenticationController());
        Get.put(BottomNavController());
      }),
      initialRoute: '/',
      getPages: [
        //GetPage(name: '/', page: () => const MainScaffold()),
        GetPage(name: '/', page: () => const App()),
        //GetPage(name: '/home', page: () => const HomePage()),
        GetPage(name: '/home', page: () => const Root()),
        GetPage(name: '/search', page: () => SearchPage()),
        GetPage(name: '/prayList', page: () => PrayListPage()),
      ],
    );
  }
}

class MainScaffolds extends StatelessWidget {
  const MainScaffolds({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<MainNavigationController>();

    final pages = [
      const HomePage(),
      SearchPage(),
      PrayListPage(),
    ];

    return Obx(() {
      final currentIndex = navController.currentIndex.value;
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('모두의 가톨릭 기도서',
              style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.orange.shade400,
          leading: const Icon(Icons.home, color: Colors.white),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.menu, color: Colors.white),
            ),
          ],
        ),
        body: pages[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: navController.changeTab,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.ac_unit), label: ''),
          ],
          selectedItemColor: Colors.orange.shade400,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      );
    });
  }
}
