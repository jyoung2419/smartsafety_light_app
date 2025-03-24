import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChooseManagerWidget extends StatefulWidget {
  final Function(String id, String name, String tel) onManagerSelected;

  const ChooseManagerWidget({super.key, required this.onManagerSelected});

  @override
  State<ChooseManagerWidget> createState() => _ChooseManagerWidgetState();
}

class _ChooseManagerWidgetState extends State<ChooseManagerWidget> {
  List<Map<String, String>> managerList = [];
  String? selectedManager;

  @override
  void initState() {
    super.initState();
    fetchManagerList();
  }

  Future<void> fetchManagerList() async {
    final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
    final String port = dotenv.env['PORT'] ?? '3000';
    final Uri url = Uri.parse('$baseUrl:$port/managerSelectList');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          managerList = data.map<Map<String, String>>((item) => {
            "label": item["label"],
            "value": item["value"],
            "tel": item["tel"] ?? ""
          }).toList();
        });
      } else {
        print("감독관 불러오기 실패: ${response.statusCode}");
      }
    } catch (e) {
      print("에러 발생: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.purpleAccent, width: 1),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "감독관 선택",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedManager,
            items: managerList.map((manager) {
              return DropdownMenuItem<String>(
                value: manager["value"],
                child: Text(manager["label"] ?? ""),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => selectedManager = value);
              if (value != null) {
                final selected = managerList.firstWhere((m) => m["value"] == value);
                widget.onManagerSelected(
                  selected["value"] ?? "",
                  selected["label"] ?? "",
                  selected["tel"] ?? "",
                );
              }
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
            hint: const Text("선택", style: TextStyle(color: Colors.grey)),
          )
        ],
      ),
    );
  }
}
