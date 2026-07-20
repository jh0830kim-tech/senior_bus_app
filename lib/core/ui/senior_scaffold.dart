import 'package:flutter/material.dart';
import 'call_bar.dart';

/// 모든 화면의 공통 뼈대 — 하단 전화 버튼(F4)이 항상 고정된다.
class SeniorScaffold extends StatelessWidget {
  final String title;
  final Widget body;

  const SeniorScaffold({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        centerTitle: true,
        toolbarHeight: 68,
      ),
      body: Padding(padding: const EdgeInsets.all(16), child: body),
      bottomNavigationBar: const CallBar(),
    );
  }
}
