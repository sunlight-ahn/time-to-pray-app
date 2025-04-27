import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
