import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChooseWorkCategoryWidget extends StatefulWidget {
  final Function(int) onDangerLevelChange;
  final Function(String) onWorkTypeChange;

  const ChooseWorkCategoryWidget({
    super.key,
    required this.onDangerLevelChange,
    required this.onWorkTypeChange,
  });

  @override
  _ChooseWorkCategoryWidgetState createState() => _ChooseWorkCategoryWidgetState();
}

class _ChooseWorkCategoryWidgetState extends State<ChooseWorkCategoryWidget> {
  int selectedDangerLevel = 3;
  String selectedWorkType = "";
  List<Map<String, dynamic>> workTypes = [];

  @override
  void initState() {
    super.initState();
    fetchWorkTypes();
  }

  Future<void> fetchWorkTypes() async {
    final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
    final String port = dotenv.env['PORT'] ?? '3000';
    final Uri url = Uri.parse('$baseUrl:$port/workSelectList');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          workTypes = data.map((item) {
            return {"label": item['label'], "value": item['value']};
          }).toList();
        });
      } else {
        print("❌ 서버 응답 오류: ${response.statusCode}");
      }
    } catch (error) {
      print("❌ 네트워크 오류: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: const Color(0xFFEB5757), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("작업 종류 선택", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFEB5757))),
          const SizedBox(height: 10),

          Row(
            children: [
              SvgPicture.asset("assets/svg/work/danger.svg", width: 13, height: 13),
              const SizedBox(width: 5),
              const Text("위험 등급", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFEB5757))),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDangerButton("고위험", 1, const Color(0xFFEB5757)),
              _buildDangerButton("위험", 2, const Color(0xFFF2994A)),
              _buildDangerButton("일반", 3, const Color(0xFF27AE60)),
            ],
          ),
          const SizedBox(height: 15),

          Row(
            children: [
              SvgPicture.asset("assets/svg/work/danger.svg", width: 13, height: 13),
              const SizedBox(width: 5),
              const Text("작업 종류", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFEB5757))),
            ],
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey.shade400, width: 1),
              color: Colors.white,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedWorkType.isEmpty ? null : selectedWorkType,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                hint: const Text("선택", style: TextStyle(color: Colors.grey)),
                items: workTypes.map<DropdownMenuItem<String>>((type) {
                  return DropdownMenuItem<String>(
                    value: type['label'],
                    child: Text(type['label']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedWorkType = value!;
                  });
                  widget.onWorkTypeChange(value!);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerButton(String label, int level, Color color) {
    bool isSelected = selectedDangerLevel == level;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDangerLevel = level;
        });
        widget.onDangerLevelChange(level);
      },
      child: Container(
        width: 90,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: color, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : color,
          ),
        ),
      ),
    );
  }
}
