import '../../domain/entities/route_plan.dart';
import '../../domain/repositories/route_repository.dart';
import '../api/route_api_client.dart';

/// ODsay API 기반 실제 구현체 — 응답을 RoutePlan으로 변환
class RouteRepositoryImpl implements RouteRepository {
  final RouteApiClient _api;

  RouteRepositoryImpl(this._api);

  @override
  Future<List<RoutePlan>> findRoutes({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
  }) async {
    final body = await _api.searchRoutes(
      fromLat: fromLat, fromLng: fromLng, toLat: toLat, toLng: toLng);

    final paths = (body['result']?['path'] as List?) ?? [];
    final plans = <RoutePlan>[];

    for (final path in paths.cast<Map<String, dynamic>>()) {
      // pathType: 1 지하철, 2 버스, 3 혼합 — 본 앱은 버스만(2) 사용
      if (path['pathType'] != 2) continue;

      final legs = <RouteLeg>[];
      final subPaths = (path['subPath'] as List?) ?? [];
      for (final sub in subPaths.cast<Map<String, dynamic>>()) {
        // trafficType: 1 지하철, 2 버스, 3 도보 — 버스 구간만 안내
        if (sub['trafficType'] != 2) continue;
        final lanes = (sub['lane'] as List?) ?? [];
        final busNo = lanes.isEmpty
            ? '?'
            : (lanes.first as Map<String, dynamic>)['busNo'].toString();
        legs.add(RouteLeg(
          routeNo: busNo,
          boardStation: sub['startName'].toString(),
          alightStation: sub['endName'].toString(),
          stationCount: int.tryParse(sub['stationCount'].toString()) ?? 0,
        ));
      }
      if (legs.isEmpty) continue;

      plans.add(RoutePlan(
        legs: legs,
        totalMinutes:
            int.tryParse(path['info']?['totalTime'].toString() ?? '') ?? 0,
      ));
    }

    plans.sort((a, b) => a.totalMinutes.compareTo(b.totalMinutes));
    return plans;
  }
}
