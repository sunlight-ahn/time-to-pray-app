import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pray_rosary_controller.dart';
import '../models/prayer.dart';

class RosaryItemPage extends StatefulWidget {
  final List<String> prayerCodes;
  final List<Prayer> prayers;

  const RosaryItemPage({
    Key? key,
    required this.prayerCodes,
    required this.prayers,
  }) : super(key: key);

  @override
  State<RosaryItemPage> createState() => _RosaryItemPageState();
}

class _RosaryItemPageState extends State<RosaryItemPage> {
  final PrayRosaryController _controller = Get.find<PrayRosaryController>();
  double _speed = 1.0;
  bool _isPlaying = false;
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller.loadPrayer(widget.prayers[0].id);
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
      _togglePlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('기도문 상세'),
        backgroundColor: const Color(0xFF53B175),
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildControlPanel(),
              const SizedBox(height: 20),
              _buildPrayerTitle(),
              const SizedBox(height: 10),
              _buildPrayerContent(),
            ],
          ),
        );
      }),
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
}
