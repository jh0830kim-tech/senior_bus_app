import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/senior_theme.dart';
import '../features/home/home_screen.dart';
import '../features/onboarding/permission_guide_screen.dart';

class SeniorBusApp extends StatelessWidget {
  const SeniorBusApp({super.key});

  /// 최초 실행 여부 확인
  Future<bool> _isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('permission_guide_done') != true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '어르신 버스도우미',
      theme: SeniorTheme.light,
      home: FutureBuilder<bool>(
        future: _isFirstLaunch(),
        builder: (context, snapshot) {
          // 로딩 중에는 빈 화면 (스플래시 역할)
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data!
              ? const PermissionGuideScreen()
              : const HomeScreen();
        },
      ),
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
