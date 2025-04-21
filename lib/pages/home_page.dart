import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '오늘도 기도와 함께 시작해요 🙏',
        style: TextStyle(fontSize: 20, color: Colors.grey[800]),
      ),
    );
  }
}
