import '../entities/bus_arrival.dart';
import '../entities/station.dart';

/// 정류장/도착정보 계약 — 어떤 API(TAGO, 지자체 BIS)를 쓰든 이 인터페이스만 구현하면 된다.
abstract class StationRepository {
  /// 좌표 기준 가까운 정류장 목록 (가까운 순)
  Future<List<Station>> findNearbyStations(double lat, double lng);

  /// 특정 정류장의 실시간 버스 도착 정보
  Future<List<BusArrival>> getArrivals(Station station);
}
