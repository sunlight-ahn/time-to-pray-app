import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/prayer.dart';
import '../repository/test_pray_repository.dart';

class PrayListPage extends StatefulWidget {
  const PrayListPage({super.key});

  @override
  State<PrayListPage> createState() => _PrayListPageState();
}

class _PrayListPageState extends State<PrayListPage> {
  final TestPrayRepository _repository = TestPrayRepository();
  List<Prayer> _prayers = [];
  int? _expandedId;

  @override
  void initState() {
    super.initState();
    final int? focusId = Get.arguments;
    _loadPrayers(focusId);
  }

  Future<void> _loadPrayers(int? focusId) async {
    final results = await _repository.searchPrayers(''); // 전체 불러오기
    setState(() {
      _prayers = results;
      _expandedId = focusId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('기도문 목록'),
        centerTitle: true,
        backgroundColor: Colors.orange.shade400,
      ),
      body: ListView.builder(
        itemCount: _prayers.length,
        itemBuilder: (context, index) {
          final prayer = _prayers[index];
          final isExpanded = prayer.id == _expandedId;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ExpansionTile(
              key: Key(prayer.id.toString()), // 고유 키 지정
              initiallyExpanded: isExpanded,
              title: Text(
                prayer.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(prayer.content),
                )
              ],
              onExpansionChanged: (expanded) {
                setState(() {
                  _expandedId = expanded ? prayer.id : null;
                });
              },
            ),
          );
        },
      ),
    );
  }
}
