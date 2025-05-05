import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pray_rosary_controller.dart';
import '../models/prayer.dart';
import '../repository/pray_repository.dart';

class RosaryItemPage extends StatefulWidget {
  final String prayKey; // 예: "환희의신비"

  // 공통 기도문 목록
  List<Map<String, dynamic>> buttonList = [];
  static const List<Map<String, dynamic>> buttonStartList = [
    {
      'title': '사도신경',
      'prayKey': '사도신경',
      'color': Color(0xFF53B175), // 강조 색상 (appBar와 동일)
    },
    {
      'title': '주님의 기도',
      'prayKey': '주님의기도',
      'color': Color(0xFF8E8E93), // 강조 색상 (appBar와 동일)
    },
    {
      'title': '성모송',
      'prayKey': '성모송',
      'color': Color(0xFF8E8E93), // 차분한 색상
    },
    {
      'title': '성모송',
      'prayKey': '성모송',
      'color': Color(0xFF8E8E93), // 차분한 색상
    },
    {
      'title': '성모송',
      'prayKey': '성모송',
      'color': Color(0xFF8E8E93), // 차분한 색상
    },
    {
      'title': '영광송',
      'prayKey': '영광송',
      'color': Color(0xFF8E8E93), // 차분한 색상
    },
    {
      'title': '구원송',
      'prayKey': '구원송',
      'color': Color(0xFF8E8E93), // 차분한 색상
    },
  ];
  static const List<Map<String, dynamic>> buttonEndList = [
    {
      'title': '성모찬송',
      'prayKey': '성모찬송',
      'color': Color(0xFF53B175),
    },
  ];
  static const List<Map<String, dynamic>> buttonMiddleList = [
    {
      'title': '주님의 기도',
      'prayKey': '주님의기도',
      'color': Color(0xFF8E8E93),
    },
    {
      'title': '성모송(1)',
      'prayKey': '성모송',
      'color': Color(0xFF8E8E93),
    },
    {
      'title': '성모송(2)',
      'prayKey': '성모송',
      'color': Color(0xFF8E8E93),
    },
    {
      'title': '성모송(3)',
      'prayKey': '성모송',
      'color': Color(0xFF8E8E93),
    },
    {
      'title': '성모송(4)',
      'prayKey': '성모송',
      'color': Color(0xFF8E8E93),
    },
    {
      'title': '성모송(5)',
      'prayKey': '성모송',
      'color': Color(0xFF8E8E93),
    },
    {
      'title': '성모송(6)',
      'prayKey': '성모송',
      'color': Color(0xFF8E8E93),
    },
    {
      'title': '성모송(7)',
      'prayKey': '성모송',
      'color': Color(0xFF8E8E93),
    },
    {
      'title': '성모송(8)',
      'prayKey': '성모송',
      'color': Color(0xFF8E8E93),
    },
    {
      'title': '성모송(9)',
      'prayKey': '성모송',
      'color': Color(0xFF8E8E93),
    },
    {
      'title': '성모송(10)',
      'prayKey': '성모송',
      'color': Color(0xFF8E8E93),
    },
    {
      'title': '영광송',
      'prayKey': '영광송',
      'color': Color(0xFF8E8E93), // 차분한 색상
    },
    {
      'title': '구원송',
      'prayKey': '구원송',
      'color': Color(0xFF8E8E93), // 차분한 색상
    },
  ];

  RosaryItemPage({
    Key? key,
    required this.prayKey,
  }) : super(key: key);

  @override
  State<RosaryItemPage> createState() => _RosaryItemPageState();
}

class _RosaryItemPageState extends State<RosaryItemPage> {
  final PrayRosaryController _controller = Get.find<PrayRosaryController>();
  final PrayRepository _repository = PrayRepository();
  double _speed = 1.0;
  bool _isPlaying = false;
  int _currentIndex = 0;
  Timer? _timer;
  List<Prayer> _mysteryPrayers = []; // 신비 기도문들 (예: 환희의신비1단 ~ 5단)

  int _currentMysteryIndex = 0;
  int _currentCommonIndex = 0;

  // buttonList를 동적으로 구성하는 메소드
  void _buildButtonList() {
    // 초기화
    widget.buttonList = [];

    // 시작 기도문 추가
    widget.buttonList.addAll(RosaryItemPage.buttonStartList);

    // 신비 기도문 순회
    for (int i = 0; i < _mysteryPrayers.length; i++) {
      widget.buttonList.add({
        'title': _mysteryPrayers[i].title,
        'prayKey': _mysteryPrayers[i].prayKey,
        'color': Color(0xFF8E8E93),
      });
      // 각 신비마다 중간 기도문 추가
      widget.buttonList.addAll(RosaryItemPage.buttonMiddleList);

      // 마지막 신비라면 종료 기도문 추가
      if (i == _mysteryPrayers.length - 1) {
        widget.buttonList.addAll(RosaryItemPage.buttonEndList);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPrayers();
  }

  Future<void> _loadPrayers() async {
    // 신비 기도문 로드 (예: 환희의신비1단 ~ 5단)
    for (int i = 1; i <= 5; i++) {
      final prayKey = '${widget.prayKey}$i단';
      print('_loadPrayers(), prayKey : $prayKey');
      final prayers = await _repository.getPrayersByPrayKey(prayKey);
      if (prayers.isNotEmpty) {
        _mysteryPrayers.add(prayers.first);
      }
    }

    if (_mysteryPrayers.isNotEmpty) {
      _controller.getPrayerByPrayKey(_mysteryPrayers[0].prayKey);
      // buttonList 구성
      _buildButtonList();
    }
  }

  void _nextPrayer() {
    if (_currentCommonIndex < widget.buttonList.length - 1) {
      // 현재 신비의 공통 기도문이 끝나지 않았다면 다음 공통 기도문으로
      _currentCommonIndex++;
      _controller.getPrayerByPrayKey(
          widget.buttonList[_currentCommonIndex]['prayKey'] as String);
    } else if (_currentMysteryIndex < _mysteryPrayers.length - 1) {
      // 현재 신비의 모든 공통 기도문이 끝났다면 다음 신비로
      _currentMysteryIndex++;
      _currentCommonIndex = 0;
      _controller
          .getPrayerByPrayKey(_mysteryPrayers[_currentMysteryIndex].prayKey);
    } else {
      // 모든 기도가 끝났다면
      _stopAnimation();
      Get.snackbar('완료', '모든 기도가 끝났습니다.');
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
      _currentIndex = 0;
      if (_isPlaying) {
        _nextPrayer();
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
        title: Text(
          widget.prayKey,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF53B175),
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            // 화면 너비가 600px 미만이면 세로 배치
            if (constraints.maxWidth < 600) {
              return Column(
                children: [
                  // 기도문 영역
                  Expanded(
                    child: Padding(
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
                    ),
                  ),
                  // 버튼 영역
                  Container(
                    color: Colors.grey[100],
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          '공통 기도문',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // 버튼 그리드 (4열)
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 6,
                          childAspectRatio: 2.5,
                          children: widget.buttonList
                              .map((button) => ElevatedButton(
                                    onPressed: () {
                                      _controller.getPrayerByPrayKey(
                                          button['prayKey'] as String);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: button['color'] as Color,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(3.0),
                                      ),
                                    ),
                                    child: Text(
                                      button['title'] as String,
                                      style: const TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            // 화면 너비가 600px 이상이면 가로 배치
            return Row(
              children: [
                // 왼쪽 영역 (70%)
                Expanded(
                  flex: 7,
                  child: Padding(
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
                  ),
                ),
                // 오른쪽 영역 (30%)
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.grey[100],
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          '공통 기도문',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView(
                            children: widget.buttonList
                                .map((button) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _controller.getPrayerByPrayKey(
                                              button['prayKey'] as String);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              button['color'] as Color,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        child: Text(
                                          button['title'] as String,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
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
