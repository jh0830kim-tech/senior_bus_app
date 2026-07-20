import 'package:flutter/material.dart';
import '../theme/senior_theme.dart';

/// 시니어용 대형 버튼 — 홈/목록 등 모든 주요 동작에 사용
class BigButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final Color color;

  const BigButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.color = SeniorTheme.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: SeniorTheme.onPrimary,
          minimumSize: const Size.fromHeight(96), // 홈 버튼은 더 크게
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 40),
              const SizedBox(width: 14),
            ],
            Text(label),
          ],
        ),
      ),
    );
  }
}
