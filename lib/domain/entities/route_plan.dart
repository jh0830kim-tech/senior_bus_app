/// 길찾기 결과 경로 1개
class RoutePlan {
  final List<RouteLeg> legs;   // 탑승 구간 목록 (환승이면 2개 이상)
  final int totalMinutes;      // 총 소요 시간

  const RoutePlan({required this.legs, required this.totalMinutes});

  bool get hasTransfer => legs.length > 1;
}

/// 버스 1회 탑승 구간
class RouteLeg {
  final String routeNo;        // 버스 번호
  final String boardStation;   // 타는 정류장
  final String alightStation;  // 내리는 정류장
  final int stationCount;      // 지나는 정류장 수

  const RouteLeg({
    required this.routeNo,
    required this.boardStation,
    required this.alightStation,
    required this.stationCount,
  });
}
