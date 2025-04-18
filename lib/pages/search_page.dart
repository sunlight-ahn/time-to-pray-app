import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pray_search_controller.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  final PraySearchController controller = Get.put(PraySearchController());
  final TextEditingController _searchInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.orange.shade400;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title:
            const Text('기도문 검색', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: themeColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // 🔍 검색 입력 영역
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.orange.shade50,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchInputController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: '검색어를 입력하세요',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final keyword = _searchInputController.text.trim();
                    if (keyword.isNotEmpty) {
                      controller.search(keyword);
                    } else {
                      Get.snackbar('알림', '검색어를 입력해주세요',
                          snackPosition: SnackPosition.BOTTOM);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // 📋 검색 결과 리스트
          Expanded(
            child: Obx(() {
              final results = controller.results;

              if (results.isEmpty) {
                return const Center(child: Text('검색 결과가 없습니다.'));
              }

              return ListView.builder(
                itemCount: results.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final prayer = results[index];

                  return GestureDetector(
                    onTap: () {
                      // 🔥 카드 클릭 시 기도문 ID 전달하여 이동
                      Get.toNamed('/prayers', arguments: prayer.id);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading:
                            const Icon(Icons.bookmark, color: Colors.orange),
                        title: Text(
                          prayer.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        subtitle: Text(
                          prayer.content,
                          style: const TextStyle(color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
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
