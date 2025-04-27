import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_to_pray_app/controllers/prayer_controller.dart';

class PrayerItem extends StatelessWidget {
  final PrayerController controller;
  final bool isExpanded;
  final VoidCallback onExpandToggle;
  final VoidCallback onToggleFavoriteDB;

  const PrayerItem({
    Key? key,
    required this.controller,
    required this.isExpanded,
    required this.onExpandToggle,
    required this.onToggleFavoriteDB,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final prayer = controller.prayer;
      final isFavorite = controller.isFavorite.value;

      return GestureDetector(
        onTap: onExpandToggle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Row(
                children: [
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: const Color(0xFF53B175),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      prayer.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite
                          ? Icons.bookmark
                          : Icons.bookmark_border_outlined,
                      color: isFavorite ? Colors.orange[200] : Colors.grey,
                    ),
                    onPressed: () {
                      controller.toggleFavorite();
                      onToggleFavoriteDB();
                    },
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(bottom: 16, left: 20, right: 8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    prayer.content,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
          ],
        ),
      );
    });
  }
}
