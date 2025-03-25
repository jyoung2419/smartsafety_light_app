import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/completed_work.dart';

class WorkListProvider with ChangeNotifier {
  List<Map<String, dynamic>> workList = [];
  List<CompletedWork> completedWorkList = [];

  Map<String, dynamic>? workDetail; // 작업 상세정보
  List<Map<String, dynamic>> photoBeforeList = []; // 작업 전 사진
  List<Map<String, dynamic>> photoAfterList = [];  // 작업 후 사진
  Map<String, dynamic>? signData; // 서명 데이터
  List<Map<String, dynamic>> educationList = []; // 교육 내역

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

  // 작업 전 사진 조회
  Future<void> fetchPhotoBefore(String wnum) async {
    final url = Uri.parse('$apiBase/smartSafetyDetailPhoto');
    final response = await http.post(
      url,
      headers: { 'Content-Type': 'application/json' },
      body: jsonEncode({ 'wnum': wnum }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> rawList = jsonDecode(response.body);

      photoBeforeList = rawList.map<Map<String, dynamic>>((item) {
        final map = Map<String, dynamic>.from(item);
        final imageName = map['IMAGENAME'];
        if (imageName != null && imageName is String) {
          map['IMAGE_PATH'] = '$apiBase/images/$imageName';
        } else {
          map['IMAGE_PATH'] = null;
        }
        return map;
      }).toList();

      notifyListeners();
    } else {
      debugPrint('작업 전 사진 조회 실패: ${response.statusCode}');
    }
  }

  // 작업 후 사진 조회
  Future<void> fetchPhotoAfter(String wnum) async {
    final url = Uri.parse('$apiBase/smartSafetyDetailPhotoAfter');
    final response = await http.post(
      url,
      headers: { 'Content-Type': 'application/json' },
      body: jsonEncode({ 'wnum': wnum }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> rawList = jsonDecode(response.body);

      photoAfterList = rawList.map<Map<String, dynamic>>((item) {
        final map = Map<String, dynamic>.from(item);
        final imageName = map['IMAGENAME'];
        if (imageName != null && imageName is String) {
          map['IMAGE_PATH'] = '$apiBase/images/$imageName'; // 경로 설정
        } else {
          map['IMAGE_PATH'] = null;
        }
        return map;
      }).toList();

      notifyListeners();
    } else {
      debugPrint('작업 후 사진 조회 실패: ${response.statusCode}');
    }
  }

  // 서명 이미지 조회
  Future<void> fetchSign(String wnum) async {
    final url = Uri.parse('$apiBase/smartSafetyDetailSign');
    final response = await http.post(
      url,
      headers: { 'Content-Type': 'application/json' },
      body: jsonEncode({ 'wnum': wnum }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);

      if (decoded is List && decoded.isNotEmpty) {
        final raw = Map<String, dynamic>.from(decoded.first);
        final imageName = raw['IMAGENAME'];

        if (imageName != null && imageName is String) {
          raw['SIGN_PATH'] = '$apiBase/images_sign/$imageName';
        } else {
          raw['SIGN_PATH'] = null;
        }

        signData = raw;
      } else {
        signData = null;
      }

      notifyListeners();
    } else {
      debugPrint('서명 이미지 조회 실패: ${response.statusCode}');
    }
  }

  // 교육 내역 조회
  Future<void> fetchEducationDetail(String num) async {
    final url = Uri.parse('$apiBase/safetyEducationDetail');
    final response = await http.post(
      url,
      headers: { 'Content-Type': 'application/json' },
      body: jsonEncode({ 'num': num }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      educationList = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      notifyListeners();
    } else {
      debugPrint('교육 내역 조회 실패: ${response.statusCode}');
    }
  }

  // 작업 시작 요청
  Future<void> startWork(String wnum) async {
    final url = Uri.parse('$apiBase/workDetailStart');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'wnum': wnum}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('✅ 작업 시작 성공');
      await fetchWorkDetail(wnum); // 최신 상태 반영
    } else {
      debugPrint('❌ 작업 시작 실패: ${response.statusCode}');
    }
  }

  // 작업 완료 요청
  Future<void> requestWorkEnd(String wnum, List<File> images) async {
    final url = Uri.parse('$apiBase/workDetailEndRequest');
    final request = http.MultipartRequest('POST', url);
    request.fields['wnum'] = wnum;

    for (var file in images) {
      request.files.add(await http.MultipartFile.fromPath('images', file.path));
    }

    final response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('✅ 작업 완료 요청 성공');
      await fetchWorkDetail(wnum);
    } else {
      debugPrint('❌ 작업 완료 요청 실패: ${response.statusCode}');
    }
  }

  // 상세창 숨기기
  void hideDetail() {
    detailVisible = false;
    notifyListeners();
  }
}
