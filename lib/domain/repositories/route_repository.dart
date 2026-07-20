import '../entities/route_plan.dart';

/// 길찾기 계약 (ODsay, Tmap 등 어떤 공급자든 교체 가능)
abstract class RouteRepository {
  /// 환승 포함 모든 경로 (최단시간 순 정렬)
  Future<List<RoutePlan>> findRoutes({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
  });
}
