import '../../domain/entities/place.dart';
import '../../domain/repositories/place_repository.dart';
import '../api/place_api_client.dart';

/// 카카오 로컬 기반 실제 구현체
class PlaceRepositoryImpl implements PlaceRepository {
  final PlaceApiClient _api;

  PlaceRepositoryImpl(this._api);

  @override
  Future<List<Place>> search(String query) async {
    final docs = await _api.searchKeyword(query);
    return docs.map((d) {
      final road = d['road_address_name']?.toString() ?? '';
      return Place(
        name: d['place_name'].toString(),
        address: road.isNotEmpty ? road : (d['address_name']?.toString() ?? ''),
        lat: double.parse(d['y'].toString()), // 카카오: y=위도, x=경도
        lng: double.parse(d['x'].toString()),
      );
    }).toList();
  }
}
