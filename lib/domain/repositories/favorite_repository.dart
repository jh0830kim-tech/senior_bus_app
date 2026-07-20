import '../entities/favorite_place.dart';

/// 자주 가는 장소 저장 계약 (현재: 로컬저장, 향후: 보호자 서버 연동으로 교체 가능)
abstract class FavoriteRepository {
  Future<List<FavoritePlace>> getAll();
  Future<void> add(FavoritePlace place);
  Future<void> remove(String id);
}
