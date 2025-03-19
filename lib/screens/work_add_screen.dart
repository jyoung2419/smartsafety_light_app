import 'package:flutter/material.dart';
import '../widgets/header.dart';
import 'package:intl/intl.dart';
import '../widgets/work_add/choose_work_category_widget.dart';
import '../widgets/work_add/work_info_add_widget.dart';
import '../widgets/work_add/worker_info_add_widget.dart';
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
                    onDangerLevelChange: (int level) {
                      print("선택한 위험 등급: $level");
                    },
                    onWorkTypeChange: (int type) {
                      print("선택한 작업 종류: $type");
                    },
                  ),
                  const SizedBox(height: 20),
                  WorkInfoAddWidget(
                    onWorkNameChange: (value) => setState(() => workName = value),
                    onStartDateChange: (date) => setState(() => startDate = date),
                    onEndDateChange: (date) => setState(() => endDate = date),
                    onWorkPlaceChange: (value) => setState(() => workPlace = value),
                    onWorkContentChange: (value) => setState(() => workContent = value),
                  ),
                  const SizedBox(height: 20),
                  // const WorkerInfoAddWidget(),
                  // const SizedBox(height: 20),
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
                        style: TextStyle(fontSize: 18, color: Colors.white),
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