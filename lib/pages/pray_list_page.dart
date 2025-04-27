import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:time_to_pray_app/controllers/bottom_nav_controller.dart';
import 'package:time_to_pray_app/controllers/prayer_controller.dart';
import 'package:time_to_pray_app/pages/prayer_item.dart';
//import 'package:time_to_pray_app/models/prayer.dart';
//import 'package:time_to_pray_app/repository/test_pray_repository.dart';
import 'package:time_to_pray_app/repository/pray_repository.dart';

class PrayListPage extends StatefulWidget {
  PrayListPage({super.key});

  @override
  State<PrayListPage> createState() => _PrayListPageState();
}

class _PrayListPageState extends State<PrayListPage> {
  final PrayRepository _repository = PrayRepository();
  final Logger _logger = Logger();
  final TextEditingController _searchInputController = TextEditingController();

  List<PrayerController> _prayers = [];
  int? _expandedId; // 펼쳐진 prayer id

  @override
  void initState() {
    super.initState();
    _loadPrayers();
  }

  Future<void> _loadPrayers({String? keyword}) async {
    final results = await _repository.searchPrayers(keyword ?? '');
    setState(() {
      _prayers =
          results.map((prayer) => PrayerController(prayer: prayer)).toList();
    });
  }

  void _onSearch() {
    final keyword = _searchInputController.text.trim();
    _logger.i('검색 키워드: $keyword');
    _loadPrayers(keyword: keyword.isEmpty ? null : keyword);
  }

  void _toggleExpand(int id) {
    setState(() {
      if (_expandedId == id) {
        _expandedId = null;
      } else {
        _expandedId = id;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 2),
          Expanded(
            child: _prayers.isEmpty
                ? const Center(
                    child: Text(
                      '검색 결과가 없습니다.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    itemCount: _prayers.length,
                    separatorBuilder: (_, __) => const Divider(
                      color: Colors.blueGrey,
                      height: 1,
                      thickness: 1,
                    ),
                    itemBuilder: (context, index) {
                      final prayerController = _prayers[index];
                      return PrayerItem(
                        controller: prayerController,
                        isExpanded: _expandedId == prayerController.prayer.id,
                        onExpandToggle: () =>
                            _toggleExpand(prayerController.prayer.id),
                        onToggleFavoriteDB: () async {
                          await _repository.updateFavoriteStatus(
                            prayerController.prayer.id,
                            prayerController.isFavorite.value,
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(40),
      child: AppBar(
        backgroundColor: const Color(0xFF53B175),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.find<BottomNavController>().changeBottomNav(0);
          },
        ),
        title: const Text(
          '가톨릭 기도문',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        height: 50,
        decoration: ShapeDecoration(
          color: const Color(0xFFF1F2F2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Color(0xFF53B175)),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchInputController,
                decoration: const InputDecoration(
                  hintText: '기도문 검색',
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _onSearch(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 18),
              onPressed: _onSearch,
            ),
          ],
        ),
      ),
    );
  }
}
