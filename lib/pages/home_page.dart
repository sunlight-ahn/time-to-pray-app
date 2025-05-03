import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repository/pray_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final prayRepository = PrayRepository();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await prayRepository.initDB();
          await prayRepository.clearPrayers();
          await prayRepository.initData();
          Get.snackbar(
            '초기화 완료',
            '더미 데이터가 저장되었습니다.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black87,
            colorText: Colors.white,
          );
        },
        backgroundColor: const Color(0xFF53B175),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      //backgroundColor: Colors.white, // 여기서 배경색 설정
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          title: const Text(
            '모두의 가톨릭 기도서',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Gilroy-Medium',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: 3,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF53B175), //Colors.orange.shade400,
          // leading: const Icon(Icons.home, color: Colors.white),
          // actions: const [
          //   Padding(
          //     padding: EdgeInsets.only(right: 16.0),
          //     child: Icon(Icons.menu, color: Colors.white),
          //   ),
          // ],
        ),
      ),
      body: Center(
        child: Text(
          '오늘도 기도와 함께 시작해요 🙏',
          style: TextStyle(fontSize: 20, color: Colors.grey[800]),
        ),
      ),
    );
  }
}
