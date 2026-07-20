import 'dart:convert';
import 'package:http/http.dart' as http;

/// ODsay 대중교통 길찾기 API 클라이언트
/// https://lab.odsay.com 에서 키 발급 (무료 플랜 있음)
class RouteApiClient {
  final String apiKey;

  RouteApiClient(this.apiKey);

  /// 대중교통 경로 검색 (SX/SY: 출발 경도/위도, EX/EY: 도착 경도/위도)
  Future<Map<String, dynamic>> searchRoutes({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
  }) async {
    final uri = Uri.https('api.odsay.com', '/v1/api/searchPubTransPathT', {
      'apiKey': apiKey,
      'SX': '$fromLng',
      'SY': '$fromLat',
      'EX': '$toLng',
      'EY': '$toLat',
      'SearchPathType': '2', // 2 = 버스만 (지하철 제외)
    });
    final res = await http.get(uri).timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) {
      throw Exception('길찾기 서버 오류 (${res.statusCode})');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (body['error'] != null) {
      throw Exception('길찾기 API 오류: ${body['error']}');
    }
    return body;
  }
}
