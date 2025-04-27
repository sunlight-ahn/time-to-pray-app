import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:time_to_pray_app/controllers/bottom_nav_controller.dart';
import '../models/prayer.dart';
import '../repository/test_pray_repository.dart';
import '../repository/pray_repository.dart';

class PrayListPage extends StatefulWidget {
  PrayListPage({super.key});

  @override
  State<PrayListPage> createState() => _PrayListPageState();
}

class _PrayListPageState extends State<PrayListPage> {
  //final TestPrayRepository _repository = TestPrayRepository();
  final PrayRepository _repository = PrayRepository();

  final Logger _logger = Logger();
  final TextEditingController _searchInputController = TextEditingController();

  List<Prayer> _prayers = [];
  int? _expandedId;

  @override
  void initState() {
    super.initState();
    _loadPrayers(); // 앱 시작 시 전체 목록 불러오기
  }

  Future<void> _loadPrayers({String? keyword}) async {
    final results = await _repository.searchPrayers(keyword ?? '');
    setState(() {
      _prayers = results;
    });
  }

  void _onSearch() {
    final keyword = _searchInputController.text.trim();
    _logger.i('검색 키워드: $keyword');
    _loadPrayers(keyword: keyword.isEmpty ? null : keyword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
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
          //centerTitle: true,
          title: const Text(
            '가톨릭 기도문', // 원하는 타이틀 텍스트로 수정 가능
            style: TextStyle(
              fontSize: 17, // 작게
              fontWeight: FontWeight.w500, // 볼드  FontWeight.bold,
              color: Colors.white, // 흰색
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // 🔍 검색 입력 영역
          Padding(
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
          ),
          const SizedBox(height: 2),
          // 📝 기도문 리스트
          Expanded(
            child: _prayers.isEmpty
                ? const Center(
                    child: Text(
                      '검색 결과가 없습니다.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 1,
                      bottom: 2,
                    ),
                    itemCount: _prayers.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.blueGrey,
                      height: 1,
                      thickness: 1,
                    ),
                    itemBuilder: (context, index) {
                      return _prayerItem(_prayers[index]);
                    },
                  ),
          ),
        ],
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
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
            child: Row(
              children: [
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: const Color(0xFF53B175),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    prayer.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis, // 제목 길면 ... 처리
                  ),
                ),
                IconButton(
                  icon: Icon(
                    prayer.isFavorite
                        ? Icons.bookmark
                        : Icons.bookmark_border_outlined,
                    color: Colors.orange[200],
                  ),
                  visualDensity: VisualDensity.compact, // ← 공간 줄이기
                  padding: EdgeInsets.zero, // ← 내부 여백 제거
                  constraints: const BoxConstraints(), // ← 크기 제약 최소화
                  onPressed: () => _toggleFavorite(prayer),
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 20, right: 4),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5), // 원하는 배경색 넣기 (연한 회색 예시)
                  borderRadius: BorderRadius.circular(8), // 둥근 모서리도 가능
                ),
                child: Text(
                  prayer.content,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(Prayer prayer) {
    setState(() {
      // 여기에 prayer.isFavorite 반전하는 로직 추가 가능
      final updatedPrayer = prayer.copyWith(isFavorite: !prayer.isFavorite);
      //prayer.isFavorite = !prayer.isFavorite;
    });
    //_logger.i('${updatedPrayer.title} 즐겨찾기 상태: ${updatedPrayer.isFavorite}');
  }
}
