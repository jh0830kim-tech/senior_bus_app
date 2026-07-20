import 'package:flutter_test/flutter_test.dart';
import 'package:senior_bus_app/data/repositories/mock_repositories.dart';
import 'package:senior_bus_app/domain/usecases/find_routes.dart';
import 'package:senior_bus_app/domain/usecases/manage_favorites.dart';

void main() {
  test('빠른 길과 편한 길을 구분해 반환한다', () async {
    final usecase = FindRoutes(MockLocationRepository(), MockRouteRepository());
    final result = await usecase.call(toLat: 37.54, toLng: 126.95);

    expect(result.fastest, isNotNull);
    expect(result.direct, isNotNull);
    expect(result.direct!.hasTransfer, isFalse); // 편한 길은 환승 없음
  });

  test('자주 가는 곳은 최대 6개까지만 저장된다', () async {
    final usecase = ManageFavorites(MockFavoriteRepository());
    final all = await usecase.getAll();
    expect(all.length, lessThanOrEqualTo(ManageFavorites.maxCount));
  });
}
