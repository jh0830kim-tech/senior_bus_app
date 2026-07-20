import '../entities/place.dart';

/// 장소 검색 계약 (카카오, 네이버 등 어떤 공급자든 교체 가능)
abstract class PlaceRepository {
  Future<List<Place>> search(String query);
}
