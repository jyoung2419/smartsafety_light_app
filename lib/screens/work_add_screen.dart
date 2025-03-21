import 'package:flutter/material.dart';
import '../widgets/header.dart';
import 'package:intl/intl.dart';
import '../widgets/work_add/choose_work_category_widget.dart';
import '../widgets/work_add/work_info_add_widget.dart';
import '../widgets/work_add/worker_add/worker_info_add_widget.dart';
import '../widgets/work_add/worker_add/worker_edu_modal.dart';
import '../widgets/work_add/work_picture_add_widget.dart';
import '../widgets/work_add/choose_manager_widget.dart';


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
  String? workerId;
  String? workerName;
  String? workerTel;

  List<Map<String, dynamic>> workers = [];

  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyyMMddHHmmss').format(dateTime);
  }

  // 서버 전송 로직
  void submitWork() {
    final List<String> userIdList = workers.map((w) => w["USERID"].toString()).toList();

    final List<String> eduList = workers
        .expand((w) => (w["educationList"] ?? []))
        .cast<String>()
        .toSet()
        .toList();

    print("👷 작업자 ID 목록: $userIdList");
    print("📚 교육 항목 목록: $eduList");

    final workData = {
      "WNAME": workName,
      "WSTART": formatDateTime(startDate),
      "WEND": formatDateTime(endDate),
      "WPLACE": workPlace,
      "WCONTENT": workContent,
      "DANGER_STATE": dangerState,
      "DNAME": dname,
      "USERID": workerId,
      "WUSER": workerName,
      "WSTATE": 0,
      "WTEL": workerTel,
      "safetyEducationList": eduList,
      "REGDATE": formatDateTime(DateTime.now()),
      // 기타 DNUM, TYPE_STATE, WSTATE 등도 필요 시 추가
    };

    print("서버 전송 데이터: $workData");
    // 실제 API 요청 로직 추가 (ex: HTTP POST 요청)
    // POST 요청 예시
    // final uri = Uri.parse('${dotenv.env["BASE_URL"]}:${dotenv.env["PORT"]}/work');
    // final response = await http.post(uri, body: jsonEncode(workData), headers: {
    //   "Content-Type": "application/json",
    // });
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
                    onWorkTypeChange: (type) => setState(() => dname = type),
                  ),
                  const SizedBox(height: 20),
                  WorkInfoAddWidget(
                    onWorkNameChange: (value) => setState(() => workName = value),
                    onStartDateChange: (date) => setState(() => startDate = date),
                    onEndDateChange: (date) => setState(() => endDate = date),
                    onWorkPlaceChange: (value) => setState(() => workPlace = value),
                    onWorkContentChange: (value) => setState(() => workContent = value),
                    onSubmitWork: (workData) => submitWork(),
                  ),
                  const SizedBox(height: 20),
                  WorkerInfoAddWidget(
                    onWorkerIdChange: (id) => setState(() => workerId = id),
                    onWorkerNameChange: (name) => setState(() => workerName = name),
                    onWorkerTelChange: (tel) => setState(() => workerTel = tel),
                    navigateToQRCode: navigateToQRCode,
                    onWorkerConfirmed: (list) => setState(() => workers = list),
                  ),
                  const SizedBox(height: 20),
                  // const WorkPictureAddWidget(),
                  // const SizedBox(height: 20),
                  // const ChooseManagerWidget(),
                  // const SizedBox(height: 30),
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
                      onPressed: () {
                        // 작업 승인 요청 로직 추가
                      },
                      child: const Text(
                        "작업 승인 요청",
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
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