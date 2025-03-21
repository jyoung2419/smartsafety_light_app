import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'worker_edu_modal.dart';

class WorkerModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onWorkerSelected;

  const WorkerModal({super.key, required this.onWorkerSelected});

  @override
  _WorkerModalState createState() => _WorkerModalState();
}

class _WorkerModalState extends State<WorkerModal> {
  String? selectedCompany;
  String? selectedWorker;
  List<Map<String, dynamic>> companyList = [];
  List<Map<String, dynamic>> workerList = [];

  @override
  void initState() {
    super.initState();
    fetchCompanyList();
  }

  Future<void> fetchCompanyList() async {
    final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
    final String port = dotenv.env['PORT'] ?? '3000';
    final Uri url = Uri.parse('$baseUrl:$port/workAddCompanyList');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          companyList = [
            {"label": "선택", "value": null},
            ...data.map((item) {
              return {"label": item['label'], "value": item['value'].toString()};
            }).toList()
          ];
        });
      } else {
        print("❌ 서버 응답 오류: ${response.statusCode}");
      }
    } catch (error) {
      print("❌ 네트워크 오류: $error");
    }
  }

  Future<void> fetchWorkerList(String companyId) async {
    final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
    final String port = dotenv.env['PORT'] ?? '3000';
    final Uri url = Uri.parse('$baseUrl:$port/workAddWorkerList?companyId=$companyId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          workerList = [
            {"label": "선택", "value": null},
            ...data.map((item) {
              return {
                "label": item['label'],
                "value": item['value'].toString(),
                "tel": item['tel']
              };
            }).toList()
          ];
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
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.all(15),
      content: SizedBox(
        width: 250,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const Text(
              "파트너사 선택",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 45,
              child: DropdownButtonFormField<String>(
                value: selectedCompany,
                items: companyList.map((company) {
                  return DropdownMenuItem<String>(
                    value: company['value'],
                    child: Text(
                      company['label'],
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCompany = value!;
                    selectedWorker = null;
                    workerList.clear();
                  });
                  if (value != null) fetchWorkerList(value);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "작업자 선택",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 45,
              child: DropdownButtonFormField<String>(
                value: selectedWorker,
                items: workerList.map((worker) {
                  return DropdownMenuItem<String>(
                    value: worker['value'],
                    child: Text(
                      worker['label'],
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                  onChanged: (value) async {
                    if (value != null) {
                      setState(() {
                        selectedWorker = value;
                      });
                      final selectedWorkerData = workerList.firstWhere((w) => w["value"] == value);

                      final confirmedWorker = await showDialog<Map<String, dynamic>>(
                        context: context,
                        builder: (BuildContext context) {
                          return WorkerEduModal(
                            worker: selectedWorkerData,
                            closeModal: () => Navigator.of(context).pop(),
                            onConfirm: (_) {},
                          );
                        },
                      );

                      if (confirmedWorker != null) {
                        Navigator.of(context).pop(confirmedWorker);
                      }
                    }
                  },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
