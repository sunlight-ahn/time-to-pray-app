import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_to_pray_app/controllers/bottom_nav_controller.dart';
import 'package:time_to_pray_app/pages/home_page.dart';
import 'package:time_to_pray_app/pages/pray_list_page.dart';
import 'package:time_to_pray_app/pages/search_page.dart';

class Root extends GetView<BottomNavController> {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.tabController,
          children: [
            HomePage(),
            SearchPage(),
            PrayListPage(),
            Center(child: Text("기타")),
          ]),
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
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.ac_unit), label: ''),
          ],
        ),
      ),
    );
  }
}
