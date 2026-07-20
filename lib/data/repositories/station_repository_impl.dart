import '../../core/utils/geo_utils.dart';
import '../../domain/entities/bus_arrival.dart';
import '../../domain/entities/station.dart';
import '../../domain/repositories/station_repository.dart';
import '../api/bus_api_client.dart';

/// TAGO API 기반 실제 구현체
class StationRepositoryImpl implements StationRepository {
  final BusApiClient _api;

  StationRepositoryImpl(this._api);

  @override
  Future<List<Station>> findNearbyStations(double lat, double lng) async {
    final items = await _api.getNearbyStations(lat, lng);
    final stations = items.map((e) {
      final sLat = (e['gpslati'] as num).toDouble();
      final sLng = (e['gpslong'] as num).toDouble();
      return Station(
        id: e['nodeid'].toString(),
        name: e['nodenm'].toString(),
        lat: sLat,
        lng: sLng,
        cityCode: int.tryParse(e['citycode'].toString()) ?? 0,
        distanceMeters: GeoUtils.distanceMeters(lat, lng, sLat, sLng),
      );
    }).toList()
      ..sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
    return stations;
  }

  @override
  Future<List<BusArrival>> getArrivals(Station station) async {
    final items = await _api.getArrivals(station.cityCode, station.id);
    final arrivals = items.map((e) {
      final seconds = int.tryParse(e['arrtime'].toString()) ?? 0;
      return BusArrival(
        routeNo: e['routeno'].toString(),
        etaMinutes: (seconds / 60).ceil(),
        direction: e['routetp']?.toString() ?? '',
      );
    }).toList()
      ..sort((a, b) => a.etaMinutes.compareTo(b.etaMinutes));
    return arrivals;
  }
}
