import 'package:flutter/material.dart';

class NavItem extends StatelessWidget {
  final String title;
  final int index;
  final int currentIndex;
  final GlobalKey keyl;
  final Function(GlobalKey) onTap;
  final bool isDarkMode;

  const NavItem({
    super.key,
    required this.title,
    required this.index,
    required this.currentIndex,
    required this.keyl,
    required this.onTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onTap(keyl),
      style: TextButton.styleFrom(
        foregroundColor: currentIndex == index ? Colors.blue : (isDarkMode ? Colors.white70 : Colors.black54),
        padding: const EdgeInsets.symmetric(horizontal: 15),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: currentIndex == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}