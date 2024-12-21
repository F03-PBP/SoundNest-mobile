import 'package:flutter/material.dart';

class TitleBox extends StatelessWidget {
  final String title;
  final Color color;
  final LinearGradient gradient;

  TitleBox({
    super.key,
    required this.title,
  })  : color = _getColor(title),
        gradient = _getGradient(title);

  static Color _getColor(String title) {
    switch (title) {
      case 'Starter':
        return const Color(0xFFC56930);
      case 'Explorer':
        return const Color(0xFFFFB71E);
      case 'Pro':
        return const Color(0xFF3F3AE0);
      case 'Legendary':
        return const Color(0xFF6E9658);
      default:
        return Colors.grey;
    }
  }

  static LinearGradient _getGradient(String title) {
    switch (title) {
      case 'Starter':
        return const LinearGradient(
          colors: [Color(0xFFC56930), Color(0xFFCA9473)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Explorer':
        return const LinearGradient(
          colors: [Color(0xFFFFB71E), Color(0xFFFED98B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Pro':
        return const LinearGradient(
          colors: [Color(0xFF3F3AE0), Color(0xFF9B99DC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Legendary':
        return const LinearGradient(
          colors: [Color(0xFF6E9658), Color(0xFF8FC274)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Colors.grey, Colors.grey],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 16, left: 4, top: 4, bottom: 4),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            // color: Colors.black.withValues(alpha: 0.25), // ini kalo flutter upgrade
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
