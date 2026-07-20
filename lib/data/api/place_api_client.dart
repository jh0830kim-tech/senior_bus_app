import 'dart:convert';
import 'package:http/http.dart' as http;

/// 카카오 로컬 API — 키워드 장소 검색
/// developers.kakao.com 에서 앱 생성 후 "REST API 키" 사용
class PlaceApiClient {
  final String restApiKey;

  PlaceApiClient(this.restApiKey);

  Future<List<Map<String, dynamic>>> searchKeyword(String query) async {
    final uri = Uri.https('dapi.kakao.com', '/v2/local/search/keyword.json', {
      'query': query,
      'size': '7', // 어르신 화면에 부담 없는 개수
    });
    final res = await http
        .get(uri, headers: {'Authorization': 'KakaoAK $restApiKey'})
        .timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) {
      throw Exception('장소 검색 서버 오류 (${res.statusCode})');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return ((body['documents'] as List?) ?? []).cast<Map<String, dynamic>>();
  }
}
