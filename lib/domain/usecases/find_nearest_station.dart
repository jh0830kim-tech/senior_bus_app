import '../entities/bus_arrival.dart';
import '../entities/station.dart';
import '../repositories/location_repository.dart';
import '../repositories/station_repository.dart';

/// F1: 검색 버튼 → 가장 가까운 정류장 + 그 정류장의 버스 도착 정보
class FindNearestStation {
  final LocationRepository _location;
  final StationRepository _station;

  FindNearestStation(this._location, this._station);

  Future<({Station station, List<BusArrival> arrivals})> call() async {
    final pos = await _location.getCurrentLocation();
    final stations = await _station.findNearbyStations(pos.lat, pos.lng);
    if (stations.isEmpty) {
      throw Exception('근처에 정류장이 없어요');
    }
    final nearest = stations.first;
    final arrivals = await _station.getArrivals(nearest);
    return (station: nearest, arrivals: arrivals);
  }
}
