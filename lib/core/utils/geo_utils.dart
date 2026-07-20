import 'dart:math';

/// 좌표 간 거리 계산 (하버사인 공식)
class GeoUtils {
  static int distanceMeters(double lat1, double lng1, double lat2, double lng2) {
    const r = 6371000.0; // 지구 반지름(m)
    final dLat = _rad(lat2 - lat1);
    final dLng = _rad(lng2 - lng1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_rad(lat1)) * cos(_rad(lat2)) * sin(dLng / 2) * sin(dLng / 2);
    return (r * 2 * atan2(sqrt(a), sqrt(1 - a))).round();
  }

  static double _rad(double deg) => deg * pi / 180;
}
