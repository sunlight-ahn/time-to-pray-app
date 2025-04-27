import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/prayer_controller.dart';

class PrayerItem extends StatelessWidget {
  final PrayerController controller;
  final VoidCallback onToggleFavoriteDB;

  const PrayerItem({
    Key? key,
    required this.controller,
    required this.onToggleFavoriteDB,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final prayer = controller.prayer;
      final isFavorite = controller.isFavorite.value;

      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
        title: Text(
          prayer.title,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.bookmark : Icons.bookmark_border_outlined,
            color: isFavorite ? Colors.orange[200] : Colors.grey,
          ),
          onPressed: () {
            controller.toggleFavorite(); // 메모리만 반영
            onToggleFavoriteDB(); // DB 저장 따로
          },
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        onTap: () {
          // 추가 기능 넣을 수 있음 (예: 펼치기 등)
        },
      );
    });
  }
}
