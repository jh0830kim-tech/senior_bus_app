import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_constants.dart';
import '../theme/senior_theme.dart';

/// F4: 모든 화면 하단에 고정되는 전화 서비스콜 버튼
class CallBar extends StatelessWidget {
  const CallBar({super.key});

  Future<void> _call() async {
    final uri = Uri(scheme: 'tel', path: AppConstants.serviceCallNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: SeniorTheme.callGreen,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(SeniorTheme.minTouchTarget),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: _call,
          icon: const Icon(Icons.call, size: 34),
          label: const Text('전화로 물어보기'),
        ),
      ),
    );
  }
}
