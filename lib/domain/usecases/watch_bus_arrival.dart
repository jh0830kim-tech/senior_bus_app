import '../entities/bus_arrival.dart';
import '../entities/station.dart';
import '../repositories/station_repository.dart';

/// F6-1: 탑승 안내 화면에서 대기시간을 주기적으로 갱신하는 스트림
class WatchBusArrival {
  final StationRepository _station;
  static const refreshInterval = Duration(seconds: 30);

  WatchBusArrival(this._station);

  Stream<List<BusArrival>> call(Station station) async* {
    while (true) {
      yield await _station.getArrivals(station);
      await Future<void>.delayed(refreshInterval);
    }
  }
}
