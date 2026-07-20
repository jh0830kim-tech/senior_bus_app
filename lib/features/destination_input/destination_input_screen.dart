import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../app/di.dart';
import '../../core/theme/senior_theme.dart';
import '../../core/ui/big_text.dart';
import '../../core/ui/senior_scaffold.dart';
import '../../domain/entities/place.dart';
import '../route_search/route_search_screen.dart';

/// F2 목적지 입력 — 어르신용 2가지 방법:
///  ① "눌러서 말하기" (음성 입력, 기본 권장)
///  ② 큰 글씨 텍스트 입력
/// 검색 결과는 큰 카드로 표시, 누르면 바로 길찾기로 이동
class DestinationInputScreen extends ConsumerStatefulWidget {
  const DestinationInputScreen({super.key});

  @override
  ConsumerState<DestinationInputScreen> createState() =>
      _DestinationInputScreenState();
}

class _DestinationInputScreenState
    extends ConsumerState<DestinationInputScreen> {
  final _controller = TextEditingController();
  final _speech = SpeechToText();

  bool _speechReady = false;
  bool _listening = false;
  bool _loading = false;
  List<Place>? _results;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _speechReady = await _speech.initialize(
      onStatus: (status) {
        // 말이 끝나면 자동으로 검색 실행
        if (status == 'notListening' && _listening) {
          setState(() => _listening = false);
          if (_controller.text.trim().isNotEmpty) _search();
        }
      },
    );
    if (mounted) setState(() {});
  }

  Future<void> _toggleListen() async {
    if (!_speechReady) return;
    if (_listening) {
      await _speech.stop();
      setState(() => _listening = false);
      return;
    }
    setState(() {
      _listening = true;
      _results = null;
      _controller.clear();
    });
    await _speech.listen(
      localeId: 'ko_KR',
      onResult: (result) {
        setState(() => _controller.text = result.recognizedWords);
      },
    );
  }

  Future<void> _search() async {
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    try {
      final results = await ref.read(searchPlacesProvider).call(_controller.text);
      setState(() => _results = results);
    } catch (_) {
      setState(() => _results = []);
    } finally {
      setState(() => _loading = false);
    }
  }

  void _select(Place place) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => RouteSearchScreen(
          destinationName: place.name,
          toLat: place.lat,
          toLng: place.lng,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SeniorScaffold(
      title: '어디로 가시나요?',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ① 음성 입력 (주 방법)
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _listening ? SeniorTheme.danger : SeniorTheme.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(96),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: _speechReady ? _toggleListen : null,
            icon: Icon(_listening ? Icons.hearing : Icons.mic, size: 44),
            label: Text(_listening ? '듣고 있어요...' : '눌러서 말하기'),
          ),
          const SizedBox(height: 8),
          BigText(
            _speechReady ? '예) "공덕역" 이라고 말해보세요' : '글씨로 적어주세요',
            size: 20,
            weight: FontWeight.normal,
          ),
          const SizedBox(height: 12),

          // ② 텍스트 입력 (보조)
          TextField(
            controller: _controller,
            style: const TextStyle(fontSize: 26),
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _search(),
            decoration: InputDecoration(
              hintText: '또는 여기에 적기',
              hintStyle: const TextStyle(fontSize: 24),
              suffixIcon: IconButton(
                iconSize: 36,
                icon: const Icon(Icons.search),
                onPressed: _search,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 12),

          // 결과 목록
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 6));
    }
    final results = _results;
    if (results == null) return const SizedBox.shrink();
    if (results.isEmpty) {
      return const Center(
          child: BigText('찾지 못했어요.\n다르게 말해보세요.', size: 24));
    }
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, i) {
        final place = results[i];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _select(place),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.name,
                      style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: SeniorTheme.primary)),
                  const SizedBox(height: 4),
                  Text(place.address,
                      style: const TextStyle(
                          fontSize: 20, color: Colors.black54)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
