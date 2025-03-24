import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../widgets/header.dart';
import 'package:intl/intl.dart';
import '../widgets/workAdd/choose_work_category_widget.dart';
import '../widgets/workAdd/work_info_add_widget.dart';
import '../widgets/workAdd/worker_add/worker_info_add_widget.dart';
import '../widgets/work_picture_add_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/workAdd/choose_manager_widget.dart';


class WorkAddScreen extends StatefulWidget {
  const WorkAddScreen({super.key});
  @override
  _WorkAddScreenState createState() => _WorkAddScreenState();
}

class _WorkAddScreenState extends State<WorkAddScreen> {
  String workName = "";
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String workPlace = "";
  String workContent = "";
  int dangerState = 3;
  String dname = "";
  int dnum = 0;
  String? loginUserId = "";
  String? managerName;
  String? managerTel;
  String? managerUserId;

  List<Map<String, dynamic>> workers = [];
  List<File> _selectedImages = [];

  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyyMMddHHmmss').format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    loadLoginUserInfo();
  }

  void loadLoginUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      loginUserId = prefs.getString('loginUserId') ?? '';
    });
  }
  // 서버 전송 로직
  Future<void> handleSubmitWork() async {
    try {
      final List<String> userIdList = workers.map((w) => w["WORKERID"].toString()).toList();
      final List<String> eduList = workers
          .expand((w) => (w["educationList"] as List<dynamic>? ?? []))
          .cast<String>()
          .toSet()
          .toList();

      final workData = {
        "WNAME": workName,
        "WSTART": formatDateTime(startDate),
        "WEND": formatDateTime(endDate),
        "WPLACE": workPlace,
        "WCONTENT": workContent,
        "DANGER_STATE": dangerState,
        "DNAME": dname,
        "DNUM": dnum,
        "CHEMINAME": "",
        "userid": loginUserId,
        "usernm": managerName,
        "usertel": managerTel,
        "WSTATE": 0,
        "TYPE_STATE": 5,
        "CKEY": 1,
        "LIDX": workPlace,
        "WPERSONNEL": workers.length,
        "workManIdx": userIdList,
        "safetyEducationList": eduList,
        "REGDATE": formatDateTime(DateTime.now()),
        "MUSER": managerUserId,
      };
      print("📦 전송할 workData: ${jsonEncode(workData)}");

      final uri = Uri.parse('${dotenv.env["BASE_URL"]}:${dotenv.env["PORT"]}/smartSafetyListInsert');
      final request = http.MultipartRequest('POST', uri);

      request.fields['data'] = jsonEncode(workData);

      for (var file in _selectedImages) {
        request.files.add(await http.MultipartFile.fromPath('images', file.path));
      }

      final response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final respStr = await response.stream.bytesToString();
        final decoded = jsonDecode(respStr);
        final int wnum = decoded['idx'];

        print("✅ 작업 등록 완료: WNUM = $wnum");

        // 서명 전송
        await uploadSignImages(
          wnum: wnum,
          workManIds: workers.map((w) => w["WORKERID"].toString()).toList(),
          signFiles: workers.map((w) => File(w["signPath"])).toList(),
        );
      } else {
        print("❌ 작업 등록 실패: ${response.statusCode}");
      }
    } catch (e) {
      print("🚨 오류 발생: $e");
    }
  }

  Future<void> uploadSignImages({
    required int wnum,
    required List<String> workManIds,
    required List<File> signFiles,
  }) async {
    final uri = Uri.parse('${dotenv.env["BASE_URL"]}:${dotenv.env["PORT"]}/smartSafetyInsertSign');
    final request = http.MultipartRequest('POST', uri);

    final signData = {
      "idx": wnum,
      "workManIdx": workManIds,
    };

    request.fields['data'] = jsonEncode(signData); // JSON으로 묶어 전송

    for (int i = 0; i < signFiles.length; i++) {
      final file = signFiles[i];
      request.files.add(http.MultipartFile.fromBytes(
        'images_sign',
        await file.readAsBytes(),
        filename: file.path.split('/').last,
      ));
    }

    final response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("✅ 서명 이미지 전송 완료");
    } else {
      print("❌ 서명 이미지 전송 실패: ${response.statusCode}");
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("작업 승인 완료"),
        content: const Text("작업 승인이 완료되었습니다."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text("확인"),
          ),
        ],
      ),
    );
  }

  // QR코드 촬영 화면으로 이동
  void navigateToQRCode() {
    print("QR코드 촬영 화면 이동");
    // TODO: QR코드 촬영 페이지 연결
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          const Header(
            title: "작업 등록",
            backgroundColor: const Color(0xFFF2F2F2),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ChooseWorkCategoryWidget(
                    onDangerLevelChange: (level) => setState(() => dangerState = level),
                    onWorkTypeChange: (String name, int? num) => setState(() {
                      dname = name;
                      dnum = num ?? 0;
                    }),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  WorkInfoAddWidget(
                    onWorkNameChange: (value) => setState(() => workName = value),
                    onStartDateChange: (date) => setState(() => startDate = date),
                    onEndDateChange: (date) => setState(() => endDate = date),
                    onWorkPlaceChange: (value) => setState(() => workPlace = value),
                    onWorkContentChange: (value) => setState(() => workContent = value),
                    onSubmitWork: (_) => handleSubmitWork(),
                  ),
                  const SizedBox(height: 20),
                  WorkerInfoAddWidget(
                    navigateToQRCode: navigateToQRCode,
                    onWorkerConfirmed: (list) => setState(() => workers = list),
                  ),
                  const SizedBox(height: 20),
                  WorkPhotoUploadWidget(
                    onImageSelected: (images) => setState(() => _selectedImages = images),
                    mode: "register",
                    isEditable: true,
                  ),
                  const SizedBox(height: 20),
                  ChooseManagerWidget(
                    onManagerSelected: (id, name, tel) {
                      setState(() {
                        managerUserId = id;
                        managerName = name;
                        managerTel = tel;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF33CCC3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: handleSubmitWork,
                      child: const Text("작업 승인 요청", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}