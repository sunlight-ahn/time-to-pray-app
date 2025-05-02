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
  List<int> _currentPrayerSequence = [];
  int _currentPrayerIndex = 0;

  @override
  void initState() {
    super.initState();
    // 초기 화면에서는 묵주기도 유형을 선택하게 됨
    setRosaryPlay(RosaryType.joyful); // 환희의 신비 시작
  }

  void setRosaryPlay(RosaryType rosaryType) {
    switch (rosaryType) {
      case RosaryType.joyful:
        _currentPrayerSequence = [7, 8]; // 예시 값
        break;
      case RosaryType.luminous:
        _currentPrayerSequence = [6, 7]; // 예시 값
        break;
      case RosaryType.sorrowful:
        _currentPrayerSequence = [5, 6]; // 예시 값
        break;
      case RosaryType.glorious:
        _currentPrayerSequence = [6, 8]; // 예시 값
        break;
    }
    _currentPrayerIndex = 0;
    _loadNextPrayer();
  }

  void _loadNextPrayer() {
    if (_currentPrayerIndex < _currentPrayerSequence.length) {
      _controller.loadPrayer(_currentPrayerSequence[_currentPrayerIndex]);
      _currentPrayerIndex++;
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
        if (_controller.currentPrayer.value == null) {
          return const Center(child: Text('기도문을 찾을 수 없습니다.'));
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_left),
                    onPressed: () => _adjustSpeed(false),
                  ),
                  Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: Text(_speed.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 10)),
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
              ),
              const SizedBox(height: 20),
              Obx(() => Text(
                    _controller.currentPrayer.value?.title ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: _controller.currentPrayer.value!.content
                              .substring(0, _currentIndex),
                          style:
                              const TextStyle(color: Colors.red, fontSize: 15),
                        ),
                        TextSpan(
                          text: _controller.currentPrayer.value!.content
                              .substring(_currentIndex),
                          style: const TextStyle(
                              color: Colors.black87, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
