import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final TextStyle? textStyle;

  const SectionTitle({
    super.key,
    required this.title,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: textStyle ??
          TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: <Color>[Colors.blueAccent, Colors.purpleAccent],
              ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
          ),
    );
  }
}
