/// 버스 정류장
class Station {
  final String id;          // 정류장 고유 ID (TAGO의 nodeId)
  final String name;        // 정류장 이름
  final double lat;
  final double lng;
  final int distanceMeters; // 현재 위치로부터 거리
  final int cityCode;       // 도시 코드 (TAGO 도착정보 조회에 필요)

  const Station({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    this.distanceMeters = 0,
    this.cityCode = 0,
  });

  /// 도보 시간(분). 어르신 보행 속도 기준(분당 약 50m)
  int get walkMinutes => (distanceMeters / 50).ceil();
}
