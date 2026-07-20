import '../entities/place.dart';
import '../repositories/place_repository.dart';

/// F2 보조: 목적지 장소 검색
class SearchPlaces {
  final PlaceRepository _repo;

  SearchPlaces(this._repo);

  Future<List<Place>> call(String query) async {
    final q = query.trim();
    if (q.isEmpty) return [];
    return _repo.search(q);
  }
}
