import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import '../models/skill_model.dart';

class SkillsList extends StatelessWidget {
  final bool isDarkMode;
  final List<SkillModel> skills;

  const SkillsList({super.key, required this.isDarkMode, required this.skills});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: skills.map((skill) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF252525) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      skill.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: skill.level * 100),
                      duration: const Duration(seconds: 2),
                      builder: (context, value, child) {
                        return Text(
                          '${value.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: skill.level),
                  duration: const Duration(seconds: 2),
                  builder: (context, value, child) {
                    return LinearProgressIndicator(
                      value: value,
                      backgroundColor: Colors.grey[300],
                      color: Colors.blueAccent,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(5),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}