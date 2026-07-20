import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/di.dart';
import '../../core/theme/senior_theme.dart';
import '../../core/ui/big_text.dart';
import '../../core/ui/senior_scaffold.dart';
import '../../domain/entities/route_plan.dart';
import '../ride_guide/ride_guide_screen.dart';

/// F2: 길찾기 — 빠른 길(환승 포함 최단시간) / 편한 길(환승 없음)
/// 목적지는 목적지 입력 화면(음성/검색) 또는 자주 가는 곳에서 넘어온다.
class RouteSearchScreen extends ConsumerStatefulWidget {
  final String destinationName;
  final double toLat;
  final double toLng;

  const RouteSearchScreen({
    super.key,
    required this.destinationName,
    required this.toLat,
    required this.toLng,
  });

  @override
  ConsumerState<RouteSearchScreen> createState() => _RouteSearchScreenState();
}

class _RouteSearchScreenState extends ConsumerState<RouteSearchScreen> {
  ({RoutePlan? fastest, RoutePlan? direct})? _result;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _search(widget.toLat, widget.toLng);
  }

  Future<void> _search(double lat, double lng) async {
    setState(() => _loading = true);
    final result = await ref.read(findRoutesProvider).call(toLat: lat, toLng: lng);
    setState(() {
      _result = result;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SeniorScaffold(
      title: widget.destinationName,
      body: _loading || _result == null
          ? const Center(child: CircularProgressIndicator(strokeWidth: 6))
          : _RouteResult(result: _result!),
    );
  }
}

/// 결과: 탭 2개 — 빠른 길 / 편한 길
class _RouteResult extends StatelessWidget {
  final ({RoutePlan? fastest, RoutePlan? direct}) result;
  const _RouteResult({required this.result});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            labelStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            tabs: [Tab(text: '빠른 길'), Tab(text: '편한 길')],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _PlanView(plan: result.fastest, emptyText: '경로를 찾지 못했어요'),
                _PlanView(plan: result.direct, emptyText: '환승 없는 버스가 없어요'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanView extends StatelessWidget {
  final RoutePlan? plan;
  final String emptyText;
  const _PlanView({required this.plan, required this.emptyText});

  @override
  Widget build(BuildContext context) {
    final p = plan;
    if (p == null) return Center(child: BigText(emptyText));

    return Column(
      children: [
        const SizedBox(height: 16),
        BigText('약 ${p.totalMinutes}분 걸려요', size: 28),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: p.legs.length,
            itemBuilder: (context, i) {
              final leg = p.legs[i];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BigText('${i + 1}. ${leg.routeNo}번 버스',
                          size: 26, color: SeniorTheme.primary),
                      const SizedBox(height: 6),
                      Text('타는 곳: ${leg.boardStation}',
                          style: const TextStyle(fontSize: 22)),
                      Text('내리는 곳: ${leg.alightStation} (${leg.stationCount}개 정류장)',
                          style: const TextStyle(fontSize: 22)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => RideGuideScreen(plan: p))),
          child: const Text('이 길로 안내받기'),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
