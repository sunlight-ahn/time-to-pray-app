import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/prayer_controller.dart';
import 'memory_training_page.dart';

class FavoritePrayItem extends StatelessWidget {
  final PrayerController controller;
  final bool isExpanded;
  final VoidCallback onExpandToggle;
  final VoidCallback onToggleFavoriteDB;
  final VoidCallback onCheck;

  const FavoritePrayItem({
    Key? key,
    required this.controller,
    required this.isExpanded,
    required this.onExpandToggle,
    required this.onToggleFavoriteDB,
    required this.onCheck,
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
                    icon: const Icon(Icons.text_snippet_outlined,
                        color: Color(0xFF53B175)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MemoryTrainingPage(
                            title: prayer.title,
                            content: prayer.content,

                          ),
                        ),
                      );
                    },
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
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
              firstCurve: Curves.easeInOut,
              secondCurve: Curves.easeInOut,
              sizeCurve: Curves.easeInOut,
            ),
          ],
        ),
      );
    });
  }
}
