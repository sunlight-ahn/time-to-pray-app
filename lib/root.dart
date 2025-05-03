import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_to_pray_app/controllers/bottom_nav_controller.dart';
import 'package:time_to_pray_app/pages/favorite_list_page.dart';
import 'package:time_to_pray_app/pages/home_page.dart';
import 'package:time_to_pray_app/pages/pray_list_page.dart';
import 'package:time_to_pray_app/pages/pray_rosary_page.dart';
import 'package:time_to_pray_app/pages/search_page.dart';
import 'package:time_to_pray_app/repository/pray_repository.dart'; // 추가 필요

class Root extends GetView<BottomNavController> {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    final PrayRepository prayRepository = PrayRepository(); // 여기서 인스턴스 생성

    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.tabController,
        children: [
          HomePage(),
          PrayListPage(),
          //SearchPage(),
          FavoriteListPage(),
          //const Center(child: Text("기타")),
          ParagraphReaderPage(),
        ],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.menuIndex.value,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xff212123),
          selectedItemColor: const Color(0xffffffff),
          unselectedItemColor: const Color(0xffffffff),
          selectedFontSize: 11.0,
          unselectedFontSize: 11.0,
          onTap: controller.changeBottomNav,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.library_books), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.ac_unit), label: ''),
          ],
        ),
      ),
      
    );
  }
}
