import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pray_search_controller.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  final PraySearchController controller = Get.put(PraySearchController());
  final TextEditingController _searchInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('검색'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // 🔍 검색 입력 영역
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchInputController,
                    decoration: const InputDecoration(
                      hintText: '검색어를 입력하세요',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final keyword = _searchInputController.text.trim();
                    if (keyword.isNotEmpty) {
                      controller.search(keyword); // 🔍 검색 실행
                    } else {
                      Get.snackbar('알림', '검색어를 입력해주세요',
                          snackPosition: SnackPosition.BOTTOM);
                    }
                  },
                  child: const Text('검색'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '검색 결과',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // 📋 검색 결과 리스트
          Expanded(
            child: Obx(() {
              final results = controller.results;

              if (results.isEmpty) {
                return const Center(
                  child: Text('검색 결과가 없습니다.'),
                );
              }

              return ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final prayer = results[index];
                  return ListTile(
                    leading: const Icon(Icons.bookmark),
                    title: Text(prayer.title),
                    subtitle: Text(prayer.content),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
