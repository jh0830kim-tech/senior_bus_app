import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/di.dart';
import '../../core/theme/senior_theme.dart';
import '../../core/ui/big_button.dart';
import '../../core/ui/big_text.dart';
import '../../core/ui/senior_scaffold.dart';
import '../../domain/entities/favorite_place.dart';
import '../route_search/route_search_screen.dart';

/// F5: 자주 가는 곳 — 누르면 바로 길찾기, 길게 누르면 삭제
class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  List<FavoritePlace> _places = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final places = await ref.read(manageFavoritesProvider).getAll();
    setState(() => _places = places);
  }

  Future<void> _confirmDelete(FavoritePlace place) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: BigText('"${place.name}"\n지울까요?', size: 26),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('아니요', style: TextStyle(fontSize: 26)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('네, 지워요',
                style: TextStyle(fontSize: 26, color: SeniorTheme.danger)),
          ),
        ],
      ),
    );
    if (yes == true) {
      await ref.read(manageFavoritesProvider).remove(place.id);
      _load();
    }
  }

  Future<void> _addPlace() async {
    // MVP: 이름 입력 + 현재 위치 저장 (향후: 지도에서 위치 선택)
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const BigText('장소 이름을 적어주세요', size: 24),
        content: TextField(
          controller: controller,
          style: const TextStyle(fontSize: 26),
          decoration: const InputDecoration(hintText: '예) 딸네 집'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('저장', style: TextStyle(fontSize: 26)),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;

    try {
      final pos = await ref.read(locationRepoProvider).getCurrentLocation();
      await ref.read(manageFavoritesProvider).add(FavoritePlace(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: name,
            lat: pos.lat,
            lng: pos.lng,
          ));
      _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString(), style: const TextStyle(fontSize: 22))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SeniorScaffold(
      title: '자주 가는 곳',
      body: Column(
        children: [
          const BigText('누르면 바로 길을 찾아드려요\n(길게 누르면 지우기)',
              size: 20, weight: FontWeight.normal),
          const SizedBox(height: 8),
          Expanded(
            child: _places.isEmpty
                ? const Center(child: BigText('아직 저장된 곳이 없어요'))
                : ListView(
                    children: [
                      for (final place in _places)
                        GestureDetector(
                          onLongPress: () => _confirmDelete(place),
                          child: BigButton(
                            label: place.name,
                            icon: Icons.place,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RouteSearchScreen(
                                  destinationName: place.name,
                                  toLat: place.lat,
                                  toLng: place.lng,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
          BigButton(
            label: '새 장소 넣기',
            icon: Icons.add,
            color: const Color(0xFF37474F),
            onTap: _addPlace,
          ),
        ],
      ),
    );
  }
}
