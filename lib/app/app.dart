import 'package:flutter/material.dart';
import '../core/theme/senior_theme.dart';
import '../features/home/home_screen.dart';

class SeniorBusApp extends StatelessWidget {
  const SeniorBusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '어르신 버스도우미',
      theme: SeniorTheme.light,
      home: const HomeScreen(),
      // 시스템 글자 크기 확대(최대 200%) 지원
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(
            textScaler: media.textScaler.clamp(maxScaleFactor: 2.0),
          ),
          child: child!,
        );
      },
    );
  }
}
