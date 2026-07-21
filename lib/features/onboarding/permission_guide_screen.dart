import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/senior_theme.dart';
import '../../core/ui/big_button.dart';
import '../../core/ui/big_text.dart';
import '../home/home_screen.dart';

/// 최초 실행 시 위치 권한 안내 화면 (어르신용)
///
/// 홈 화면보다 먼저 표시되며, 버튼을 누르면
/// 시스템 권한 팝업을 띄운 뒤 HomeScreen으로 이동한다.
class PermissionGuideScreen extends StatelessWidget {
  const PermissionGuideScreen({super.key});

  Future<void> _onConfirm(BuildContext context) async {
    // 시스템 위치 권한 요청
    await Geolocator.requestPermission();

    // 권한 결과와 관계없이 완료 플래그 저장
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('permission_guide_done', true);

    // HomeScreen으로 교체 이동 (뒤로가기 불가)
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SeniorTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // 큰 위치 아이콘
              Icon(
                Icons.location_on,
                size: 120,
                color: SeniorTheme.primary,
              ),
              const SizedBox(height: 40),

              // 안내 문구 1 — 28pt
              const BigText(
                '가까운 정류장을 찾으려면\n내 위치가 필요해요',
                size: 28,
              ),
              const SizedBox(height: 28),

              // 안내 문구 2 — 24pt, 버튼명 강조
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 24,
                    color: SeniorTheme.textColor,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(text: '다음 화면에서\n'),
                    TextSpan(
                      text: '[앱 사용 중에만 허용]',
                      style: TextStyle(
                        color: SeniorTheme.primary,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(text: ' 을\n눌러주세요'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 안심 문구 — 20pt
              const BigText(
                '위치는 앱을 쓸 때만 사용되고,\n끄면 사용되지 않아요',
                size: 20,
                weight: FontWeight.w500,
                color: Color(0xFF555555),
              ),

              const Spacer(flex: 3),

              // 하단 대형 버튼
              BigButton(
                label: '네, 알겠어요',
                icon: Icons.check_circle_outline,
                onTap: () => _onConfirm(context),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
