import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../widgets/work_grade_widget.dart';
import '../widgets/work_status_widget.dart';
import '../widgets/work_people_widget.dart';
import '../widgets/header.dart';

class WorkStatusScreen extends StatefulWidget {
  const WorkStatusScreen({super.key});

  @override
  _WorkStatusScreenState createState() => _WorkStatusScreenState();
}

class _WorkStatusScreenState extends State<WorkStatusScreen> {
  Map<String, int> workStatus = {
    "one": 0,
    "two": 0,
    "three": 0,
    "workListWait": 0,
    "workListIng": 0,
    "workListEnd": 0,
    "worKPeopleAll": 0,
    "worKPeopleIng": 0,
    "worKPeopleEnd": 0,
  };

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWorkStatus();
  }

  Future<void> fetchWorkStatus() async {
    final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
    final String port = dotenv.env['PORT'] ?? '3000';
    final Uri url = Uri.parse('$baseUrl:$port/web/work/dashboard.json');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          setState(() {
            workStatus = {
              "one": data[0]['one'],
              "two": data[0]['two'],
              "three": data[0]['three'],
              "workListWait": data[0]['workListWait'],
              "workListIng": data[0]['workListIng'],
              "workListEnd": data[0]['workListEnd'],
              "worKPeopleAll": data[0]['worKPeopleAll'],
              "worKPeopleIng": data[0]['worKPeopleIng'],
              "worKPeopleEnd": data[0]['worKPeopleEnd'],
            };
            isLoading = false;
          });
        }
      } else {
        print("❌ 서버 응답 오류: ${response.statusCode}");
      }
    } catch (error) {
      print("❌ 네트워크 오류: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double padding = 15.0;
    final double headerHeight = 100.0;
    final double widgetSpacing = 20.0;

    final double availableHeight = screenHeight - headerHeight - (padding * 2) - (widgetSpacing * 2);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          const Header(
            title: "작업 현황",
            backgroundColor: Color(0xFFF2F2F2),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
              children: [
                SizedBox(
                  height: availableHeight * 0.21,
                  child: WorkGradeWidget(
                    highRisk: workStatus["one"]!,
                    mediumRisk: workStatus["two"]!,
                    lowRisk: workStatus["three"]!,
                  ),
                ),
                const SizedBox(height: 17),
                SizedBox(
                  height: availableHeight * 0.37,
                  child: WorkStatusWidget(
                    waiting: workStatus["workListWait"]!,
                    inProgress: workStatus["workListIng"]!,
                    completed: workStatus["workListEnd"]!,
                  ),
                ),
                const SizedBox(height: 17),
                SizedBox(
                  height: availableHeight * 0.37,
                  child: WorkPeopleWidget(
                    totalPeople: workStatus["worKPeopleAll"]!,
                    inProgressPeople: workStatus["worKPeopleIng"]!,
                    completedPeople: workStatus["worKPeopleEnd"]!,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
