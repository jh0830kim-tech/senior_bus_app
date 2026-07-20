import 'package:flutter/material.dart';

/// 시니어 친화 테마 — 큰 글씨, 높은 대비, 큰 터치 영역
/// 모든 화면은 반드시 이 테마의 값만 사용한다 (개별 화면에서 임의 크기 금지)
class SeniorTheme {
  // 최소 기준
  static const double minTouchTarget = 64; // 버튼 최소 높이 (dp)
  static const double bodyFontSize = 22;
  static const double titleFontSize = 30;
  static const double buttonFontSize = 26;

  // 고대비 색상 (WCAG AA 이상)
  static const Color primary = Color(0xFF0D47A1);   // 진한 파랑
  static const Color onPrimary = Colors.white;
  static const Color background = Colors.white;
  static const Color textColor = Color(0xFF111111); // 거의 검정
  static const Color danger = Color(0xFFB71C1C);    // 삭제/경고
  static const Color callGreen = Color(0xFF1B5E20); // 전화 버튼

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: bodyFontSize, color: textColor, height: 1.4),
          titleLarge: TextStyle(
              fontSize: titleFontSize, color: textColor, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(minTouchTarget),
            textStyle: const TextStyle(
                fontSize: buttonFontSize, fontWeight: FontWeight.bold),
          ),
        ),
      );
}
