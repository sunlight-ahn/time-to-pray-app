import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:time_to_pray_app/controllers/bottom_nav_controller.dart';
import '../models/prayer.dart';
import '../repository/test_pray_repository.dart';
import '../controllers/pray_search_controller.dart';

class PrayListPage extends StatefulWidget {
  PrayListPage({super.key});

  @override
  State<PrayListPage> createState() => _PrayListPageState();
}

class _PrayListPageState extends State<PrayListPage> {
  final TestPrayRepository _repository = TestPrayRepository();
  final PraySearchController _searchController = Get.find();
  final Logger _logger = Logger();
  final TextEditingController _searchInputController = TextEditingController();

  List<Prayer> _prayers = [];
  int? _expandedId;

  @override
  void initState() {
    super.initState();
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          backgroundColor: const Color(0xFF53B175), //Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            //onPressed: () => Navigator.of(context).pop(),
            onPressed: () {
              //Get.find<MainNavigationController>().changeTab(0);
              Get.find<BottomNavController>().changeBottomNav(0);
            },
          ),
        ),
      ),
      body: Column(
        children: [
          // 🔍 검색창
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 51.57,
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
                      onSubmitted: (value) => () {}, //_onSearch(),
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 18),
                      onPressed: () {} //_onSearch,
                      ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8), // 간격 추가
          // 리스트 영역
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: 24,
              ),
              itemCount: _prayers.length,
              separatorBuilder: (context, index) => const Divider(
                color: Colors.blueGrey, // Color(0xFFDDDDDD),
                height: 1,
                thickness: 1,
              ),
              itemBuilder: (context, index) {
                return _prayerItem(_prayers[index]);
              },
            ),
          ),
        ],
        // child: Obx(() {
        //   final focusedId = _searchController.focusedPrayerId.value;
        //   if (focusedId != null && focusedId != _expandedId) {
        //     _expandedId = focusedId;
        //     _searchController.clearFocusedPrayerId();
        //     _logger.i('Obx - set _expandedId to $focusedId');
        //   }

        //   return ListView.separated(
        //     padding:
        //         const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 24),
        //     itemCount: _prayers.length,
        //     separatorBuilder: (context, index) => const Divider(
        //       color: Color(0xFFDDDDDD),
        //       height: 1,
        //       thickness: 1,
        //     ),
        //     itemBuilder: (context, index) {
        //       return _prayerItem(_prayers[index]);
        //     },
        //   );
        // }),
      ),
    );
  }

  Widget _prayerItem(Prayer prayer) {
    final isExpanded = prayer.id == _expandedId;

    return GestureDetector(
      onTap: () {
        _expandedId = isExpanded ? null : prayer.id;
        setState(() {});
      },
      behavior: HitTestBehavior.translucent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 펼치기 아이콘
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: const Color(0xFF53B175), //Colors.orange,
                ),
                Expanded(
                  child: Text(
                    prayer.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
                // ⭐ 즐겨찾기 아이콘
                IconButton(
                  icon: Icon(
                    prayer.isFavorite ? Icons.star : Icons.star_border,
                    color: Colors.orangeAccent,
                  ),
                  onPressed: () => _toggleFavorite(prayer),
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 4, right: 4),
              child: Text(
                prayer.content,
                style: const TextStyle(color: Colors.black87, fontSize: 13),
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          )
        ],
      ),
    );
  }

  void _toggleFavorite(Prayer prayer) {
    setState(() {
      //prayer.isFavorite = !prayer.isFavorite;
    });
    _logger.i('${prayer.title} 즐겨찾기 상태: ${prayer.isFavorite}');
  }
}
