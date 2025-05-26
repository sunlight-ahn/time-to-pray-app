import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repository/pray_repository.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final prayRepository = PrayRepository();
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy년 MM월 dd일');
    final formattedDate = dateFormat.format(now);
    const hasSecondReading = false; // 제2독서 데이터 존재 여부

    return Scaffold(
      floatingActionButton: Visibility(
        visible: false,
        child: FloatingActionButton(
          onPressed: () async {
            await prayRepository.initialize();
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
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/main-img-06.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 20,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        //color: Color(0xFF484848),
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Gilroy-Medium',
                      ),
                      children: [
                        // TextSpan(text: formattedDate.substring(0, 9)),
                        // TextSpan(
                        //   text: formattedDate.substring(9),
                        //   style: const TextStyle(fontWeight: FontWeight.bold),
                        // ),
                        TextSpan(
                          text: formattedDate,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 30,
                  top: 50,
                  child: const Text(
                    '(백)부활 제3주간 토요일',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Gilroy-Medium',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFFE3F2FD), // 첫 번째 Container - 강한 파란색 계열
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.asset(
                          'assets/images/main-img-08.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 3,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          color: Color(0xFF484848),
                        ),
                        children: [
                          TextSpan(
                            text: '제1독서\n',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextSpan(
                            text: '사도행전 9,31-42\n',
                            style: TextStyle(fontSize: 14),
                          ),
                          TextSpan(
                            text: '제2독서\n',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextSpan(
                            text: '사도행전 9,31-42\n',
                            style: TextStyle(fontSize: 14),
                          ),
                          TextSpan(
                            text: '복음\n',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextSpan(
                            text: '요한복음 6,60ㄴ-69',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFFC8E6C9), // 두 번째 Container - 약간 더 진한 녹색
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.asset(
                          'assets/images/main-img-02.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 3,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          color: Color(0xFF484848),
                        ),
                        children: [
                          TextSpan(
                            text: '오늘의 말씀\n',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextSpan(
                            text: '하느님께서는 여러분을 평화롭게 살라고 부르셨습니다. (1코린7,15)\n',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
