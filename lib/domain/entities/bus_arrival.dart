/// 정류장에 도착 예정인 버스 1건
class BusArrival {
  final String routeNo;    // 버스 번호 (예: "1234")
  final int etaMinutes;    // 도착까지 남은 시간(분)
  final String direction;  // 방면 (예: "시청 방면")

  const BusArrival({
    required this.routeNo,
    required this.etaMinutes,
    this.direction = '',
  });
}
