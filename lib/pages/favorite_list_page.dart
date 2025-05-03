import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:time_to_pray_app/controllers/bottom_nav_controller.dart';
import 'package:time_to_pray_app/controllers/prayer_controller.dart';
import 'package:time_to_pray_app/pages/favorite_pray_item.dart';
import 'package:time_to_pray_app/repository/pray_repository.dart';

class FavoriteListPage extends StatefulWidget {
  FavoriteListPage({super.key});

  @override
  State<StatefulWidget> createState() => _FavoriteListPage();
}

class _FavoriteListPage extends State<FavoriteListPage> {
  final PrayRepository _repository = PrayRepository();
  final Logger _logger = Logger();

  List<PrayerController> _prayers = [];
  int? _expandedId; // 펼쳐진 prayer id

  @override
  void initState() {
    super.initState();
    _loadPrayers();
  }

  Future<void> _loadPrayers() async {
    final results = await _repository.getFavoritePrayers();
    setState(() {
      _prayers =
          results.map((prayer) => PrayerController(prayer: prayer)).toList();
    });
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

  void _handleCheck(int id) {
    _logger.i('기도 완료: $id');
    // TODO: 기도 완료 처리 로직 추가
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: _prayers.isEmpty
                ? const Center(
                    child: Text(
                      '즐겨찾는 기도문이 없습니다.',
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
                      return FavoritePrayItem(
                        controller: prayerController,
                        isExpanded: _expandedId == prayerController.prayer.id,
                        onExpandToggle: () =>
                            _toggleExpand(prayerController.prayer.id),
                        onToggleFavoriteDB: () async {
                          await _repository.updateFavoriteStatus(
                            prayerController.prayer.id,
                            prayerController.isFavorite.value,
                          );
                          _loadPrayers(); // 목록 새로고침
                        },
                        onCheck: () => _handleCheck(prayerController.prayer.id),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
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
        '즐겨찾는 기도문',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    ),
  );
}
