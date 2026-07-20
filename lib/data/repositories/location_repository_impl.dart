import 'package:geolocator/geolocator.dart';
import '../../domain/repositories/location_repository.dart';

/// GPS 기반 위치 구현체
class LocationRepositoryImpl implements LocationRepository {
  @override
  Future<({double lat, double lng})> getCurrentLocation() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('위치 권한이 없어요');
    }
    final pos = await Geolocator.getCurrentPosition();
    return (lat: pos.latitude, lng: pos.longitude);
  }
}
