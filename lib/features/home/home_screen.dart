import 'package:flutter/material.dart';
import '../../core/ui/big_button.dart';
import '../../core/ui/senior_scaffold.dart';
import '../favorites/favorites_screen.dart';
import '../nearby_station/nearby_station_screen.dart';
import '../destination_input/destination_input_screen.dart';

/// 홈 화면 — 큰 버튼 3개 + 하단 전화 버튼(공통)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _go(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return SeniorScaffold(
      title: '버스도우미',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigButton(
            label: '가까운 정류장 찾기',
            icon: Icons.search,
            onTap: () => _go(context, const NearbyStationScreen()),
          ),
          BigButton(
            label: '버스로 길찾기',
            icon: Icons.directions_bus,
            onTap: () => _go(context, const DestinationInputScreen()),
          ),
          BigButton(
            label: '자주 가는 곳',
            icon: Icons.star,
            color: const Color(0xFFE65100), // 주황 — 구분되는 색
            onTap: () => _go(context, const FavoritesScreen()),
          ),
        ],
      ),
    );
  }
}
