import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../models/prayer.dart';
import '../repository/test_pray_repository.dart';
import '../controllers/pray_search_controller.dart';

class PrayList2Page extends StatefulWidget {
  const PrayList2Page({super.key});

  @override
  State<PrayList2Page> createState() => _PrayList2PageState();
}

class _PrayList2PageState extends State<PrayList2Page> {
  final TestPrayRepository _repository = TestPrayRepository();
  final PraySearchController _searchController = Get.find();
  final Logger _logger = Logger();

  List<Prayer> _prayers = [];
  int? _expandedId;

  @override
  void initState() {
    super.initState();
    _expandedId = _searchController.focusedPrayerId.value;
    _searchController.clearFocusedPrayerId();
    _loadPrayers();
  }

  Future<void> _loadPrayers() async {
    final results = await _repository.searchPrayers('');
    setState(() {
      _prayers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 검색 상단 바
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FC),
                borderRadius: BorderRadius.circular(2000),
              ),
              child: Row(
                children: const [
                  SizedBox(width: 12),
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 12),
                  Text(
                    '기도문을 검색하세요.',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16,
                      fontFamily: 'Product Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Spacer(),
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Color(0xFFBDBDBD),
                    child: Icon(Icons.person, size: 18, color: Colors.white),
                  ),
                  SizedBox(width: 12),
                ],
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFDDDDDD)),
          // 리스트
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _prayers.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 24, color: Colors.grey),
              itemBuilder: (context, index) {
                final prayer = _prayers[index];
                final isExpanded = prayer.id == _expandedId;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _expandedId = isExpanded ? null : prayer.id;
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            radius: 15,
                            backgroundColor: Color(0xFFE0E0E0),
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 제목
                                Text(
                                  prayer.title,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF292829),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // 요약 + 펼침 처리
                                AnimatedCrossFade(
                                  firstChild: Text(
                                    prayer.content,
                                    maxLines: 1,
                                    overflow:
                                        TextOverflow.ellipsis, //내용이 길어지면 ...
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF5D5C5D),
                                    ),
                                  ),
                                  secondChild: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      prayer.content,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF5D5C5D),
                                      ),
                                    ),
                                  ),
                                  crossFadeState: isExpanded
                                      ? CrossFadeState.showSecond
                                      : CrossFadeState.showFirst,
                                  duration: const Duration(milliseconds: 100),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'May 6',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF292929),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
