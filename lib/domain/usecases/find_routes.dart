import '../entities/route_plan.dart';
import '../repositories/location_repository.dart';
import '../repositories/route_repository.dart';

/// F2: 목적지까지 "빠른 길"과 "편한 길"을 한 번에 계산
class FindRoutes {
  final LocationRepository _location;
  final RouteRepository _route;

  FindRoutes(this._location, this._route);

  Future<({RoutePlan? fastest, RoutePlan? direct})> call({
    required double toLat,
    required double toLng,
  }) async {
    final pos = await _location.getCurrentLocation();
    final routes = await _route.findRoutes(
      fromLat: pos.lat,
      fromLng: pos.lng,
      toLat: toLat,
      toLng: toLng,
    );
    if (routes.isEmpty) return (fastest: null, direct: null);

    // 빠른 길: 최단시간 (환승 포함 가능)
    final fastest = routes.first;
    // 편한 길: 환승 없는 경로 중 최단시간 (없으면 null)
    final directs = routes.where((r) => !r.hasTransfer).toList();
    final direct = directs.isEmpty ? null : directs.first;

    return (fastest: fastest, direct: direct);
  }
}
