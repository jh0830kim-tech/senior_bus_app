import '../entities/favorite_place.dart';
import '../repositories/favorite_repository.dart';

/// F5: 자주 가는 장소 등록/삭제/조회
class ManageFavorites {
  final FavoriteRepository _repo;
  static const int maxCount = 6; // 화면에 큰 버튼으로 다 보이는 개수

  ManageFavorites(this._repo);

  Future<List<FavoritePlace>> getAll() => _repo.getAll();

  Future<void> add(FavoritePlace place) async {
    final current = await _repo.getAll();
    if (current.length >= maxCount) {
      throw Exception('자주 가는 곳은 $maxCount개까지 저장할 수 있어요');
    }
    await _repo.add(place);
  }

  Future<void> remove(String id) => _repo.remove(id);
}
