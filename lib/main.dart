import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_to_pray_app/pages/pray_list.dart';
import 'pages/search_page.dart';

void main() {
  runApp(const TimeToPrayApp());
}

class TimeToPrayApp extends StatelessWidget {
  const TimeToPrayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Time to Pray',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.orange), // 🔶 오렌지 톤으로 변경
        useMaterial3: true,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const HomeScreen()),
        GetPage(name: '/search', page: () => SearchPage()),
        GetPage(name: '/prayers', page: () => const PrayListPage()), // 🔥 추가
      ],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<IconData> _icons = [
    Icons.home,
    Icons.search,
    Icons.favorite,
    Icons.settings,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    final selectedIcon = _icons[index];

    if (selectedIcon == Icons.home) {
      // 홈이 아닐 경우만 이동 (필요 시 조건 추가)
      if (ModalRoute.of(context)?.settings.name != '/') {
        Get.offAllNamed('/'); // 모든 라우트 제거하고 홈으로 이동
      }
    } else if (selectedIcon == Icons.search) {
      Get.toNamed('/search');
    }
    // 추후 favorite, settings도 여기에 추가 가능
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.orange.shade400;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title:
            const Text('기도의 시간', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: themeColor,
        leading: const Icon(Icons.home, color: Colors.white),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.menu, color: Colors.white),
          ),
        ],
      ),
      body: Center(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              '오늘도 기도와 함께 시작해요 🙏',
              style: TextStyle(fontSize: 20, color: Colors.grey[800]),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _icons
            .map((icon) => BottomNavigationBarItem(
                  icon: Icon(icon),
                  label: '',
                ))
            .toList(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: themeColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 8,
      ),
    );
  }
}
