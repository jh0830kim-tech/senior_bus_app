import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/senior_theme.dart';
import '../../core/ui/big_text.dart';
import '../../core/ui/senior_scaffold.dart';
import '../../domain/entities/route_plan.dart';

/// F6: 탑승 안내 — 대기 → 탑승 → (환승) → 하차
/// 한 화면에 "지금 해야 할 일 한 가지"만 크게 보여준다.
/// MVP: 버튼으로 단계 진행 (실제 버전: GPS + 도착정보 API로 자동 진행)
class RideGuideScreen extends StatefulWidget {
  final RoutePlan plan;
  const RideGuideScreen({super.key, required this.plan});

  @override
  State<RideGuideScreen> createState() => _RideGuideScreenState();
}

class _RideGuideScreenState extends State<RideGuideScreen> {
  int _step = 0;

  List<_GuideStep> get _steps {
    final steps = <_GuideStep>[];
    for (var i = 0; i < widget.plan.legs.length; i++) {
      final leg = widget.plan.legs[i];
      // ① 대기: 실제 버전은 WatchBusArrival 스트림으로 "N분 뒤" 실시간 표시
      steps.add(_GuideStep(
        icon: Icons.timer,
        text: '${leg.boardStation}에서\n${leg.routeNo}번 버스를 기다리세요',
        sub: '곧 도착 정보를 알려드려요',
      ));
      // ② 탑승 중
      steps.add(_GuideStep(
        icon: Icons.directions_bus,
        text: '${leg.routeNo}번 버스를 타셨어요',
        sub: '${leg.stationCount}개 정류장을 지나요',
      ));
      // ③ 하차 or 환승
      final isLast = i == widget.plan.legs.length - 1;
      steps.add(_GuideStep(
        icon: isLast ? Icons.flag : Icons.swap_horiz,
        text: isLast
            ? '${leg.alightStation}에서\n내리세요'
            : '${leg.alightStation}에서 내려서\n${widget.plan.legs[i + 1].routeNo}번으로 갈아타세요',
        sub: isLast ? '도착이에요! 수고하셨어요' : '천천히 이동하세요',
        vibrate: true, // 하차/환승 시 진동 알림
      ));
    }
    return steps;
  }

  void _next() {
    final steps = _steps;
    if (_step < steps.length - 1) {
      setState(() => _step++);
      if (steps[_step].vibrate) HapticFeedback.heavyImpact();
    } else {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = _steps;
    final current = steps[_step];
    final isLastStep = _step == steps.length - 1;

    return SeniorScaffold(
      title: '가는 길 안내',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(current.icon, size: 96, color: SeniorTheme.primary),
          const SizedBox(height: 24),
          BigText(current.text, size: 32),
          const SizedBox(height: 12),
          BigText(current.sub, size: 22, weight: FontWeight.normal),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _next,
            child: Text(isLastStep ? '안내 끝내기' : '다음'),
          ),
          const SizedBox(height: 8),
          BigText('${_step + 1} / ${steps.length}',
              size: 20, weight: FontWeight.normal),
        ],
      ),
    );
  }
}

class _GuideStep {
  final IconData icon;
  final String text;
  final String sub;
  final bool vibrate;
  const _GuideStep(
      {required this.icon, required this.text, required this.sub, this.vibrate = false});
}
