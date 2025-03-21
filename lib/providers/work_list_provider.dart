import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/completed_work.dart';

class WorkListProvider with ChangeNotifier {
  List<Map<String, dynamic>> workList = [];
  List<CompletedWork> completedWorkList = [];

  Map<String, dynamic>? workDetail; // 작업 상세정보
  bool detailVisible = false;

  final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  final String port = dotenv.env['PORT'] ?? '3000';

  String get apiBase => '$baseUrl:$port';

  // 실시간 작업 목록 조회
  Future<void> fetchWorkList(int dstate, int wstate) async {
    final url = Uri.parse('$apiBase/smartSafetyList');
    final response = await http.post(
      url,
      headers: { 'Content-Type': 'application/json' },
      body: jsonEncode({ 'dstate': dstate, 'wstate': wstate }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      workList = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      notifyListeners();
    } else {
      debugPrint('작업 목록 조회 실패: ${response.statusCode}');
    }
  }

  // 완료된 작업 목록 조회
  Future<void> fetchCompletedWorkList({required int dstate}) async {
    final url = Uri.parse('$apiBase/smartSafetyHis');
    final response = await http.post(
      url,
      headers: { 'Content-Type': 'application/json' },
      body: jsonEncode({ 'dstate': dstate }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      completedWorkList = (jsonDecode(response.body) as List)
          .map((e) => CompletedWork.fromJson(e))
          .toList();
      notifyListeners();
    } else {
      debugPrint('완료 작업 목록 조회 실패: ${response.statusCode}');
    }
  }

  // 작업 상세 조회 (실시간)
  Future<void> fetchWorkDetail(String wnum) async {
    final url = Uri.parse('$apiBase/smartSafetyDetailList');
    final response = await http.post(
      url,
      headers: { 'Content-Type': 'application/json' },
      body: jsonEncode({ 'wnum': wnum }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      workDetail = Map<String, dynamic>.from(jsonDecode(response.body));
      detailVisible = true;
      notifyListeners();
    } else {
      debugPrint('작업 상세 조회 실패: ${response.statusCode}');
    }
  }

  // 작업 상세 조회 (완료)
  Future<void> fetchCompletedWorkDetail(String wnum) async {
    final url = Uri.parse('$apiBase/smartSafetyDetailHis');
    final response = await http.post(
      url,
      headers: { 'Content-Type': 'application/json' },
      body: jsonEncode({ 'wnum': wnum }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      workDetail = Map<String, dynamic>.from(jsonDecode(response.body));
      detailVisible = true;
      notifyListeners();
    } else {
      debugPrint('완료 작업 상세 조회 실패: ${response.statusCode}');
    }
  }


  void hideDetail() {
    detailVisible = false;
    notifyListeners();
  }
}
