import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_to_pray_app/pages/pray_list2_page.dart';
import 'controllers/main_navigation_controller.dart';
import 'pages/home_page.dart';
import 'pages/search_page.dart';
import 'pages/pray_list_page.dart';

void main() {
  runApp(const TimeToPrayApp());
}

class TimeToPrayApp extends StatelessWidget {
  const TimeToPrayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '모두의 가톨릭 기도서',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const MainScaffold(),
    );
  }
}

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final MainNavigationController navController =
        Get.put(MainNavigationController());

    final pages = [
      const HomePage(),
      SearchPage(),
      PrayListPage(),
      PrayList2Page(),
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
        body: IndexedStack(
          index: currentIndex,
          children: pages,
        ),
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
