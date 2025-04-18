import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const HomeScreen()),
        GetPage(name: '/search', page: () => SearchPage()), // 🔍 검색 페이지 등록
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

    // 🔄 검색 아이콘 눌렀을 때 이동
    if (_icons[index] == Icons.search) {
      Get.toNamed('/search');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('기도의 시간'),
        centerTitle: true,
        leading: const Icon(Icons.home),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.menu),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          '메인',
          style: TextStyle(fontSize: 24),
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
      ),
    );
  }
}
