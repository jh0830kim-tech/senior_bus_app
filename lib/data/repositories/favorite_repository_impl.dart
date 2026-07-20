import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/favorite_place.dart';
import '../../domain/repositories/favorite_repository.dart';

/// F5: 자주 가는 장소 — 기기 로컬(shared_preferences) 저장 구현체
class FavoriteRepositoryImpl implements FavoriteRepository {
  static const _key = 'favorite_places';

  @override
  Future<List<FavoritePlace>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => FavoritePlace.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> add(FavoritePlace place) async {
    final items = await getAll()
      ..add(place);
    await _save(items);
  }

  @override
  Future<void> remove(String id) async {
    final items = await getAll()
      ..removeWhere((p) => p.id == id);
    await _save(items);
  }

  Future<void> _save(List<FavoritePlace> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(items.map((e) => e.toJson()).toList()));
  }
}
