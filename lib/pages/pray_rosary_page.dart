import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pray_reader_controller.dart';
import '../controllers/bottom_nav_controller.dart';
import '../models/enum/rosary_type.dart';

class ParagraphReaderPage extends StatefulWidget {
  const ParagraphReaderPage({super.key});

  @override
  State<ParagraphReaderPage> createState() => _ParagraphReaderPageState();
}

class _ParagraphReaderPageState extends State<ParagraphReaderPage> {
  final PrayReaderController _controller = Get.find<PrayReaderController>();
  double _speed = 1.0; // 1.0 ~ 10.0
  bool _isPlaying = false;
  int _currentIndex = 0;
  Timer? _timer;
  List<String> _currentPrayerSequence = [];
  int _currentPrayerIndex = 0;
  RosaryType? _currentRosaryType;

  @override
  void initState() {
    super.initState();
    // 초기 화면에서는 묵주기도 유형을 선택하게 됨
    //setRosaryPlay(RosaryType.joyful); // 환희의 신비 시작
  }

  void setRosaryPlay(RosaryType rosaryType) {
    _currentRosaryType = rosaryType;
    switch (rosaryType) {
      case RosaryType.joyful:
        _currentPrayerSequence = ['사도신경', '주님의기도'];
        break;
      case RosaryType.luminous:
        _currentPrayerSequence = ['사도신경', '주님의기도'];
        break;
      case RosaryType.sorrowful:
        _currentPrayerSequence = ['사도신경', '주님의기도'];
        break;
      case RosaryType.glorious:
        _currentPrayerSequence = ['사도신경', '주님의기도'];
        break;
    }
    _currentPrayerIndex = 0;
    _loadNextPrayer();
  }

  void _loadNextPrayer() {
    if (_currentPrayerIndex < _currentPrayerSequence.length) {
      _controller.loadPrayerByKey(_currentPrayerSequence[_currentPrayerIndex]);
      _currentPrayerIndex++;
    } else {
      _stopAnimation();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAnimation() {
    _isPlaying = true;
    _animateNextChar();
  }

  void _animateNextChar() {
    if (_controller.currentPrayer.value == null ||
        _currentIndex >= _controller.currentPrayer.value!.content.length - 1) {
      _loadNextPrayer();
      _currentIndex = 0;
      if (_isPlaying) {
        _animateNextChar();
      }
      return;
    }

    final currentChar = _controller.currentPrayer.value!.content[_currentIndex];
    final isWhitespace = currentChar == ' ' || currentChar == '\n';
    final delay =
        Duration(milliseconds: isWhitespace ? 300 : (200 ~/ _speed).toInt());

    _timer = Timer(delay, () {
      if (!_isPlaying) return;
      setState(() {
        _currentIndex++;
      });
      _animateNextChar();
    });
  }

  void _stopAnimation() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
    });
  }

  void _togglePlay() {
    if (_isPlaying) {
      _stopAnimation();
    } else {
      setState(() {
        _isPlaying = true;
      });
      _animateNextChar();
    }
  }

  void _adjustSpeed(bool increase) {
    setState(() {
      _speed += increase ? 0.5 : -0.5;
      if (_speed < 1.0) _speed = 1.0;
      if (_speed > 10.0) _speed = 10.0;
    });

    if (_isPlaying) {
      _stopAnimation();
      _togglePlay(); // 속도 재반영
    }
  }

/*
_buildRosaryTypeTabs(): 상단의 묵주기도 유형 선택 탭 버튼들
_buildSelectedRosaryTitle(): 선택된 묵주기도 유형 제목 표시
_buildControlPanel(): 속도 조절 및 재생/멈춤 컨트롤 패널
_buildPrayerTitle(): 현재 기도문 제목 표시
_buildPrayerContent(): 기도문 내용 표시
 */
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
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildRosaryTypeTabs(),
              const SizedBox(height: 20),
              if (_currentPrayerSequence.isEmpty)
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
                _buildControlPanel(),
                const SizedBox(height: 20),
                _buildPrayerTitle(),
                const SizedBox(height: 10),
                _buildPrayerContent(),
              ],
            ],
          ),
        );
      }),
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

  Widget _buildControlPanel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_left),
          onPressed: () => _adjustSpeed(false),
        ),
        Container(
          width: 50,
          alignment: Alignment.center,
          child: Text(
            _speed.toStringAsFixed(1),
            style: const TextStyle(fontSize: 10),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_right),
          onPressed: () => _adjustSpeed(true),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: _togglePlay,
          child: Text(_isPlaying ? '멈춤' : '시작'),
        ),
      ],
    );
  }

  Widget _buildPrayerTitle() {
    return Obx(() => Text(
          _controller.currentPrayer.value?.title ?? '',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ));
  }

  Widget _buildPrayerContent() {
    return Expanded(
      child: SingleChildScrollView(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: _controller.currentPrayer.value!.content
                    .substring(0, _currentIndex),
                style: const TextStyle(color: Colors.red, fontSize: 15),
              ),
              TextSpan(
                text: _controller.currentPrayer.value!.content
                    .substring(_currentIndex),
                style: const TextStyle(color: Colors.black87, fontSize: 15),
              ),
            ],
          ),
        ),
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

  int _getFirstPrayerId(RosaryType type) {
    switch (type) {
      case RosaryType.joyful:
        return 9;
      case RosaryType.luminous:
        return 11;
      case RosaryType.sorrowful:
        return 12;
      case RosaryType.glorious:
        return 13;
    }
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
