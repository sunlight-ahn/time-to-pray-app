import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pray_rosary_controller.dart';
import '../controllers/bottom_nav_controller.dart';
import '../models/enum/rosary_type.dart';
import '../models/prayer.dart';
import 'rosary_item_page.dart';
import 'package:logger/logger.dart';

class ParagraphReaderPage extends StatefulWidget {
  const ParagraphReaderPage({super.key});

  @override
  State<ParagraphReaderPage> createState() => _ParagraphReaderPageState();
}

class _ParagraphReaderPageState extends State<ParagraphReaderPage> {
  final Logger _logger = Logger();
  final PrayRosaryController _controller = Get.find<PrayRosaryController>();
  List<String> _currentRosaryItemCodes = []; //묵주기도 신비 유형에 따라 사용할 코드 정의
  List<Prayer> _currentRosaryPrayItems = []; //선택된 신비내용 5개

  RosaryType? _currentRosaryType;
  bool _showDetailButton = false; //묵주기도 상세 버튼 표시 여부

  @override
  void initState() {
    super.initState();
  }

  void setRosaryPlay(RosaryType rosaryType) {
    _currentRosaryType = rosaryType;
    switch (rosaryType) {
      case RosaryType.joyful:
        _currentRosaryItemCodes = ['환희의신비'];
        break;
      case RosaryType.luminous:
        _currentRosaryItemCodes = ['사도신경', '주님의기도'];
        break;
      case RosaryType.sorrowful:
        _currentRosaryItemCodes = ['사도신경', '주님의기도'];
        break;
      case RosaryType.glorious:
        _currentRosaryItemCodes = ['사도신경', '주님의기도'];
        break;
    }
    _loadRosaryItems();
  }

  Future<void> _loadRosaryItems() async {
    _currentRosaryPrayItems = [];
    for (final code in _currentRosaryItemCodes) {
      _logger.i('code: $code');
      final prayer = await _controller.getPrayerByPrayKey(code);
      if (prayer != null) {
        _currentRosaryPrayItems.add(prayer);
      }
    }
    setState(() {
      _showDetailButton = true;
    });
  }

  void _showRosaryDetail() {
    Get.dialog(
      RosaryItemPage(
        prayKey: _currentRosaryItemCodes[0],
      ),
    );
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
          title: const Text(
            '묵주기도',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildRosaryTypeTabs(),
          const SizedBox(height: 20),
          if (_currentRosaryItemCodes.isEmpty)
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/images/rosary.png',
                  width: 350,
                  height: 400,
                  fit: BoxFit.contain,
                ),
              ),
            )
          else ...[
            _buildSelectedRosaryTitle(),
            const SizedBox(height: 20),
            _buildRosaryContent(),
          ],
        ],
      ),
      floatingActionButton: _showDetailButton
          ? FloatingActionButton(
              onPressed: _showRosaryDetail,
              backgroundColor: const Color(0xFF53B175),
              child: const Icon(Icons.visibility, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildRosaryTypeTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildRosaryButton(RosaryType.joyful, '환희의 신비'),
        _buildRosaryButton(RosaryType.luminous, '빛의 신비'),
        _buildRosaryButton(RosaryType.sorrowful, '고통의 신비'),
        _buildRosaryButton(RosaryType.glorious, '영광의 신비'),
      ],
    );
  }

  Widget _buildSelectedRosaryTitle() {
    return Text(
      _getSelectedRosaryTitle(),
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildRosaryContent() {
    return Expanded(
      child: ListView.builder(
        itemCount: _currentRosaryPrayItems.length,
        itemBuilder: (context, index) {
          final prayer = _currentRosaryPrayItems[index];
          return ListTile(
            title: Text(prayer.title),
            subtitle: Text(prayer.content),
          );
        },
      ),
    );
  }

  Widget _buildRosaryButton(RosaryType type, String title) {
    final isSelected = _currentRosaryType == type;

    return ElevatedButton(
      onPressed: () {
        print('Selected: $type');
        setRosaryPlay(type);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? const Color(0xFF53B175) : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  String _getSelectedRosaryTitle() {
    if (_currentRosaryType == null) return '기도준비';

    switch (_currentRosaryType!) {
      case RosaryType.joyful:
        return '환희의 신비';
      case RosaryType.luminous:
        return '빛의 신비';
      case RosaryType.sorrowful:
        return '고통의 신비';
      case RosaryType.glorious:
        return '영광의 신비';
    }
  }
}
