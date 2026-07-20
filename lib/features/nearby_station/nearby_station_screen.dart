import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/di.dart';
import '../../core/theme/senior_theme.dart';
import '../../core/ui/big_text.dart';
import '../../core/ui/senior_scaffold.dart';

/// F1: 가장 가까운 정류장 + 버스 도착 정보
class NearbyStationScreen extends ConsumerWidget {
  const NearbyStationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = ref.read(findNearestStationProvider).call();

    return SeniorScaffold(
      title: '가까운 정류장',
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator(strokeWidth: 6));
          }
          if (snapshot.hasError) {
            return const Center(child: BigText('정류장을 찾지 못했어요.\n전화 버튼을 눌러주세요.'));
          }
          final data = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BigText(data.station.name, size: 34),
              const SizedBox(height: 6),
              BigText('걸어서 약 ${data.station.walkMinutes}분',
                  size: 24, weight: FontWeight.normal),
              const Divider(height: 32, thickness: 2),
              Expanded(
                child: ListView.separated(
                  itemCount: data.arrivals.length,
                  separatorBuilder: (_, __) => const Divider(thickness: 1),
                  itemBuilder: (context, i) {
                    final bus = data.arrivals[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        children: [
                          BigText('${bus.routeNo}번',
                              size: 30, color: SeniorTheme.primary),
                          const Spacer(),
                          BigText('${bus.etaMinutes}분 뒤', size: 28),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
