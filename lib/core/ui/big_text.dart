import 'package:flutter/material.dart';
import '../theme/senior_theme.dart';

/// 큰 글씨 텍스트 (강조용)
class BigText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight weight;

  const BigText(
    this.text, {
    super.key,
    this.size = SeniorTheme.titleFontSize,
    this.color = SeniorTheme.textColor,
    this.weight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: size, color: color, fontWeight: weight, height: 1.3),
    );
  }
}
