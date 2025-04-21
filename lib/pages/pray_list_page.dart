import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
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
    return Obx(() {
      final focusedId = _searchController.focusedPrayerId.value;
      if (focusedId != null && focusedId != _expandedId) {
        _expandedId = focusedId;
        _searchController.clearFocusedPrayerId();
        _logger.i('Obx - set _expandedId to $focusedId');
      }

      return ListView.separated(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 24),
        itemCount: _prayers.length,
        separatorBuilder: (context, index) => const Divider(
          color: Color(0xFFDDDDDD),
          height: 1,
          thickness: 1,
        ),
        itemBuilder: (context, index) {
          return _prayerItem(_prayers[index]);
        },
      );
    });
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
                Expanded(
                  child: Text(
                    prayer.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.orange,
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
            duration: const Duration(milliseconds: 300),
          )
        ],
      ),
    );
  }
}
