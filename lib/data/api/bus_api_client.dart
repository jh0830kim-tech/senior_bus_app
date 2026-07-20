import 'dart:convert';
import 'package:http/http.dart' as http;

/// 공공데이터포털 TAGO(국토교통부) 버스 API 클라이언트
/// ⚠️ 키는 공공데이터포털의 "일반 인증키(Decoding)"를 사용할 것.
///    (Encoding 키를 넣으면 이중 인코딩되어 인증 오류가 난다)
class BusApiClient {
  final String serviceKey;
  static const _host = 'apis.data.go.kr';

  BusApiClient(this.serviceKey);

  /// 좌표 기반 근접 정류소 조회
  Future<List<Map<String, dynamic>>> getNearbyStations(
      double lat, double lng) async {
    final uri = Uri.https(_host,
        '/1613000/BusSttnInfoInqireService/getCrdntPrxmtSttnList', {
      'serviceKey': serviceKey,
      'gpsLati': '$lat',
      'gpsLong': '$lng',
      'numOfRows': '10',
      'pageNo': '1',
      '_type': 'json',
    });
    return _fetchItems(uri);
  }

  /// 정류소별 버스 도착 예정 정보 조회
  Future<List<Map<String, dynamic>>> getArrivals(
      int cityCode, String nodeId) async {
    final uri = Uri.https(_host,
        '/1613000/ArvlInfoInqireService/getSttnAcctoArvlPrearngeInfoList', {
      'serviceKey': serviceKey,
      'cityCode': '$cityCode',
      'nodeId': nodeId,
      'numOfRows': '20',
      'pageNo': '1',
      '_type': 'json',
    });
    return _fetchItems(uri);
  }

  Future<List<Map<String, dynamic>>> _fetchItems(Uri uri) async {
    final res = await http.get(uri).timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) {
      throw Exception('버스 정보 서버 오류 (${res.statusCode})');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final header = body['response']?['header'];
    if (header != null && header['resultCode'] != '00') {
      throw Exception('버스 API 오류: ${header['resultMsg']}');
    }
    // TAGO 특징: 결과 0건이면 items가 빈 문자열, 1건이면 item이 객체(배열 아님)
    final items = body['response']?['body']?['items'];
    if (items == null || items is String) return [];
    final item = (items as Map<String, dynamic>)['item'];
    if (item == null) return [];
    if (item is List) return item.cast<Map<String, dynamic>>();
    return [item as Map<String, dynamic>];
  }
}
