import '../../domain/entities/bus_arrival.dart';
import '../../domain/entities/favorite_place.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/route_plan.dart';
import '../../domain/entities/station.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/repositories/place_repository.dart';
import '../../domain/repositories/route_repository.dart';
import '../../domain/repositories/station_repository.dart';

/// ─────────────────────────────────────────────
/// Mock 구현체 — API 키 없이 앱 흐름을 개발/테스트하기 위한 가짜 데이터.
/// 실제 연동 시 lib/app/di.dart 에서 실제 구현체로 교체한다.
/// ─────────────────────────────────────────────

class MockLocationRepository implements LocationRepository {
  @override
  Future<({double lat, double lng})> getCurrentLocation() async {
    return (lat: 37.5665, lng: 126.9780); // 서울시청 근처
  }
}

class MockStationRepository implements StationRepository {
  @override
  Future<List<Station>> findNearbyStations(double lat, double lng) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return const [
      Station(id: 'S001', name: '시청앞 정류장', lat: 37.5663, lng: 126.9779, distanceMeters: 120),
      Station(id: 'S002', name: '덕수궁 정류장', lat: 37.5658, lng: 126.9751, distanceMeters: 300),
    ];
  }

  @override
  Future<List<BusArrival>> getArrivals(Station station) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return const [
      BusArrival(routeNo: '1234', etaMinutes: 5, direction: '시청 방면'),
      BusArrival(routeNo: '472', etaMinutes: 9, direction: '강남 방면'),
      BusArrival(routeNo: '9401', etaMinutes: 14, direction: '분당 방면'),
    ];
  }
}

class MockRouteRepository implements RouteRepository {
  @override
  Future<List<RoutePlan>> findRoutes({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return const [
      // 빠른 길: 환승 1회, 35분
      RoutePlan(totalMinutes: 35, legs: [
        RouteLeg(routeNo: '1234', boardStation: '시청앞', alightStation: '서울역', stationCount: 4),
        RouteLeg(routeNo: '705', boardStation: '서울역', alightStation: '공덕역', stationCount: 3),
      ]),
      // 편한 길: 환승 없음, 50분
      RoutePlan(totalMinutes: 50, legs: [
        RouteLeg(routeNo: '604', boardStation: '시청앞', alightStation: '공덕역', stationCount: 11),
      ]),
    ];
  }
}

/// 메모리 저장 Mock — 실제 구현은 shared_preferences 사용 (favorite_repository_impl.dart)
class MockFavoriteRepository implements FavoriteRepository {
  final List<FavoritePlace> _items = [
    const FavoritePlace(id: 'F1', name: '딸네 집', lat: 37.55, lng: 126.97),
    const FavoritePlace(id: 'F2', name: '한마음 병원', lat: 37.57, lng: 126.98),
  ];

  @override
  Future<List<FavoritePlace>> getAll() async => List.of(_items);

  @override
  Future<void> add(FavoritePlace place) async => _items.add(place);

  @override
  Future<void> remove(String id) async => _items.removeWhere((p) => p.id == id);
}

class MockPlaceRepository implements PlaceRepository {
  @override
  Future<List<Place>> search(String query) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return [
      Place(name: '$query', address: '서울 마포구 (예시 주소)', lat: 37.5447, lng: 126.9515),
      const Place(name: '공덕역 5호선', address: '서울 마포구 마포대로 지하 100', lat: 37.5447, lng: 126.9515),
      const Place(name: '서울역', address: '서울 중구 한강대로 405', lat: 37.5563, lng: 126.9723),
    ];
  }
}
