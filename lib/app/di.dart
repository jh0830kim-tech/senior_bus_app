import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/api/bus_api_client.dart';
import '../data/api/place_api_client.dart';
import '../data/api/route_api_client.dart';
import '../data/repositories/favorite_repository_impl.dart';
import '../data/repositories/location_repository_impl.dart';
import '../data/repositories/mock_repositories.dart';
import '../data/repositories/place_repository_impl.dart';
import '../data/repositories/route_repository_impl.dart';
import '../data/repositories/station_repository_impl.dart';
import '../domain/repositories/favorite_repository.dart';
import '../domain/repositories/location_repository.dart';
import '../domain/repositories/place_repository.dart';
import '../domain/repositories/route_repository.dart';
import '../domain/repositories/station_repository.dart';
import '../domain/usecases/find_nearest_station.dart';
import '../domain/usecases/find_routes.dart';
import '../domain/usecases/manage_favorites.dart';
import '../domain/usecases/search_places.dart';
import '../domain/usecases/watch_bus_arrival.dart';

/// ─────────────────────────────────────────────
/// 의존성 조립 (DI)
///
/// API 키는 코드에 넣지 않고 실행 시 주입한다 (커밋 사고 원천 차단):
///   flutter run --dart-define=TAGO_KEY=발급키 --dart-define=ODSAY_KEY=발급키
///
/// 키가 없으면 자동으로 Mock(가짜 데이터)으로 동작하므로
/// 키 없이도 누구나 clone 후 바로 실행/개발할 수 있다.
/// ─────────────────────────────────────────────

const _tagoKey = String.fromEnvironment('TAGO_KEY');
const _odsayKey = String.fromEnvironment('ODSAY_KEY');
const _kakaoKey = String.fromEnvironment('KAKAO_KEY');

/// 각 API 키가 있으면 해당 기능만 실제 모드로 동작한다.
/// 키가 없는 기능은 Mock(가짜 데이터)으로 독립 동작.

final locationRepoProvider = Provider<LocationRepository>((ref) =>
    LocationRepositoryImpl());

final stationRepoProvider = Provider<StationRepository>((ref) =>
    _tagoKey != ''
        ? StationRepositoryImpl(BusApiClient(_tagoKey))
        : MockStationRepository());

final routeRepoProvider = Provider<RouteRepository>((ref) =>
    _odsayKey != ''
        ? RouteRepositoryImpl(RouteApiClient(_odsayKey))
        : MockRouteRepository());

final favoriteRepoProvider = Provider<FavoriteRepository>((ref) =>
    FavoriteRepositoryImpl());

/// 장소 검색: 카카오 키가 있으면 실제, 없으면 Mock
final placeRepoProvider = Provider<PlaceRepository>((ref) => _kakaoKey != ''
    ? PlaceRepositoryImpl(PlaceApiClient(_kakaoKey))
    : MockPlaceRepository());

// ── UseCases (화면은 아래 Provider만 사용한다) ──
final findNearestStationProvider = Provider((ref) => FindNearestStation(
    ref.read(locationRepoProvider), ref.read(stationRepoProvider)));

final findRoutesProvider = Provider((ref) =>
    FindRoutes(ref.read(locationRepoProvider), ref.read(routeRepoProvider)));

final manageFavoritesProvider =
    Provider((ref) => ManageFavorites(ref.read(favoriteRepoProvider)));

final watchBusArrivalProvider =
    Provider((ref) => WatchBusArrival(ref.read(stationRepoProvider)));

final searchPlacesProvider =
    Provider((ref) => SearchPlaces(ref.read(placeRepoProvider)));
