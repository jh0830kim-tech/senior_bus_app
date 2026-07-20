/// 장소 검색 결과 1건
class Place {
  final String name;     // 장소 이름 (예: "공덕역 5호선")
  final String address;  // 주소 (어르신이 맞는 곳인지 확인용)
  final double lat;
  final double lng;

  const Place({
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
  });
}
