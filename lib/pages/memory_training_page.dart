import 'package:flutter/material.dart';

class MemoryTrainingPage extends StatefulWidget {
  final String title;
  final String content;

  const MemoryTrainingPage({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  State<MemoryTrainingPage> createState() => _MemoryTrainingPageState();
}

class _MemoryTrainingPageState extends State<MemoryTrainingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<String> words;
  late List<bool> hiddenWords;
  int currentDifficulty = 0; // 0: 쉬움, 1: 중간, 2: 어려움
  bool showAnswers = false; // 정답 표시 여부

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    words = widget.content.split(' ');
    _initializeHiddenWords();

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          currentDifficulty = _tabController.index;
          _initializeHiddenWords();
        });
      }
    });
  }

  void _initializeHiddenWords() {
    int hiddenCount = 0;
    switch (currentDifficulty) {
      case 0: // 쉬움
        hiddenCount = 3;
        break;
      case 1: // 중간
        hiddenCount = 6;
        break;
      case 2: // 어려움
        hiddenCount = 10;
        break;
    }

    hiddenWords = List.generate(words.length, (index) => false);
    for (int i = 0; i < hiddenCount; i++) {
      int randomIndex;
      do {
        randomIndex = (words.length * (i + 1) ~/ (hiddenCount + 1));
      } while (hiddenWords[randomIndex]);
      hiddenWords[randomIndex] = true;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildHiddenBox() {
    return Container(
      width: 50,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  InlineSpan _buildWordText(String word) {
    return TextSpan(
      text: word,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 13,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '쉬움'),
            Tab(text: '중간'),
            Tab(text: '어려움'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(3, (index) {
          return Container(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Text.rich(
                TextSpan(
                  children: List.generate(words.length, (i) {
                    return TextSpan(
                      children: [
                        if (hiddenWords[i] && !showAnswers)
                          WidgetSpan(child: _buildHiddenBox())
                        else
                          _buildWordText(words[i]),
                        const TextSpan(text: ' '),
                      ],
                    );
                  }),
                ),
              ),
            ),
          );
        }),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'checkButton',
            onPressed: () {
              setState(() {
                showAnswers = !showAnswers;
              });
            },
            backgroundColor: const Color(0xFF53B175), // 초록색
            label: Text(showAnswers ? '외우기' : '확인'),
            icon: Icon(showAnswers ? Icons.visibility_off : Icons.check),
          ),
          const SizedBox(width: 16),
          FloatingActionButton.extended(
            heroTag: 'closeButton',
            onPressed: () {
              Navigator.pop(context);
            },
            backgroundColor: Colors.red[400], // 붉은색
            label: const Text('닫기'),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
