/// 현재 위치 조회 계약 (구현: data/repositories/location_repository_impl.dart)
abstract class LocationRepository {
  Future<({double lat, double lng})> getCurrentLocation();
}
