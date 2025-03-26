import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/sinmungo_model.dart';

class SinmungoProvider with ChangeNotifier {
  final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  final String port = dotenv.env['PORT'] ?? '3000';
  String get apiBase => '$baseUrl:$port';

  List<SinmungoModel> sinmungoList = [];
  Map<String, dynamic>? sinmungoDetail;
  List<Map<String, dynamic>> reportCodes = [];
  List<Map<String, dynamic>> actionCodes = [];

  // 신고 리스트 조회
  Future<void> fetchSinmungoList({
    required String fromDate,
    required String toDate,
    required int state,
  }) async {
    final url = Uri.parse('$apiBase/smartSafetySinmungoList');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fromDate': fromDate,
        'toDate': toDate,
        'state': state,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      sinmungoList = jsonList.map((e) => SinmungoModel.fromJson(e)).toList();
      notifyListeners();
    } else {
      debugPrint('신고 리스트 조회 실패: ${response.statusCode}');
    }
  }

  // 신고 상세 조회
  Future<void> fetchSinmungoDetail(String idx) async {
    final url = Uri.parse('$apiBase/smartSafetySinmungoDetail');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idx': idx}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> map = Map<String, dynamic>.from(jsonDecode(response.body));

      final List<Map<String, dynamic>> imgList = List<Map<String, dynamic>>.from(map['imgList'] ?? []);
      for (var img in imgList) {
        final path = img['PATH'];
        if (path != null && path is String) {
          img['PATH'] = '$apiBase/images_safety/$path';
        }
      }

      map['imgList'] = imgList;
      sinmungoDetail = map;
      notifyListeners();
    } else {
      debugPrint('신고 상세 조회 실패: ${response.statusCode}');
    }
  }

  // 신고유형 코드 조회
  Future<void> fetchReportCodes() async {
    final url = Uri.parse('$apiBase/smartSafetySinmungoReportCode');
    final response = await http.post(url);

    if (response.statusCode == 200 || response.statusCode == 201) {
      reportCodes = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      notifyListeners();
    } else {
      debugPrint('신고유형 코드 조회 실패: ${response.statusCode}');
    }
  }

  // 조치유형 코드 조회
  Future<void> fetchActionCodes() async {
    final url = Uri.parse('$apiBase/smartSafetySinmungoTakeActionCodeList');
    final response = await http.get(url);

    if (response.statusCode == 200 || response.statusCode == 201) {
      actionCodes = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      notifyListeners();
    } else {
      debugPrint('조치유형 코드 조회 실패: ${response.statusCode}');
    }
  }

  // 신고 등록
  Future<void> registerSinmungo(Map<String, dynamic> data, List<File> images) async {
    final url = Uri.parse('$apiBase/smartSafetySinmungoInsert');
    final request = http.MultipartRequest('POST', url);

    data.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    for (var file in images) {
      request.files.add(await http.MultipartFile.fromPath('images', file.path));
    }

    final response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('✅ 신고 등록 성공');
    } else {
      debugPrint('❌ 신고 등록 실패: ${response.statusCode}');
    }
  }

  // 조치 등록
  Future<void> takeAction(Map<String, dynamic> data, List<File> images) async {
    final url = Uri.parse('$apiBase/smartSafetySinmungoTakeActionRegister');
    final request = http.MultipartRequest('POST', url);

    request.fields['data'] = jsonEncode(data);

    for (var file in images) {
      request.files.add(await http.MultipartFile.fromPath('images', file.path));
    }

    final response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('✅ 조치 등록 성공');
    } else {
      debugPrint('❌ 조치 등록 실패: ${response.statusCode}');
    }
  }

  // 데이터 초기화 (필요 시 사용)
  void resetDetail() {
    sinmungoDetail = null;
    notifyListeners();
  }
}
