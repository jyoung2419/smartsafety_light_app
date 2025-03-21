import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:signature/signature.dart';
import '../../../utils/signature_util.dart';
import 'dart:typed_data';

class WorkerEduModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onConfirm;
  final Function closeModal;
  final Map<String, dynamic> worker;

  const WorkerEduModal({super.key, required this.worker, required this.onConfirm, required this.closeModal});

  @override
  _WorkerEduModalState createState() => _WorkerEduModalState();
}

class _WorkerEduModalState extends State<WorkerEduModal> {
  List<Map<String, dynamic>> educationList = [];
  List<String> checkedItems = [];
  final SignatureController _signatureController = SignatureController(penStrokeWidth: 3.0, penColor: Colors.black);

  @override
  void initState() {
    super.initState();
    fetchEducationList();
  }

  Future<void> fetchEducationList() async {
    final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
    final String port = dotenv.env['PORT'] ?? '3000';
    final Uri url = Uri.parse('$baseUrl:$port/safetyEducation?infoType=1');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          educationList = data.map((item) {
            return {
              "INFO_CD": item["INFO_CD"],
              "INFO_DESCR": item["INFO_DESCR"],
              "GUBUN_NAME": item["GUBUN_NAME"]
            };
          }).toList();
        });
      } else {
        print("❌ 서버 응답 오류: ${response.statusCode}");
      }
    } catch (error) {
      print("❌ 네트워크 오류: $error");
    }
  }

  void toggleCheck(String infoCd) {
    setState(() {
      if (checkedItems.contains(infoCd)) {
        checkedItems.remove(infoCd);
      } else {
        checkedItems.add(infoCd);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => widget.closeModal(),
              ),
            ),

            const Text(
              "작업자 교육",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFFF2994A)),
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: educationList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: educationList.length,
                itemBuilder: (context, index) {
                  final item = educationList[index];
                  return Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Row(
                      children: [
                        _buildCategoryTag(item["GUBUN_NAME"]),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item["INFO_DESCR"],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        Checkbox(
                          value: checkedItems.contains(item["INFO_CD"]),
                          onChanged: (bool? value) {
                            toggleCheck(item["INFO_CD"]);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),


            const SizedBox(height: 20),

            const Text(
              "서명",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF33CCC3)),
            ),
            const SizedBox(height: 5),

            Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Signature(
                controller: _signatureController,
                backgroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => _signatureController.clear(),
                  child: const Text("지우기", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF33CCC3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  onPressed: () async {
                    if (checkedItems.length == educationList.length) {
                      print("🖊️ 서명 완료 버튼 클릭됨");

                      final Uint8List? signatureBytes = await _signatureController.toPngBytes();
                      print("✅ 서명 이미지 생성됨");


                      if (signatureBytes != null) {
                        final String filePath = await SignatureUtil.saveSignatureToFile(signatureBytes);
                        print("📁 서명 파일 저장 완료: $filePath");
                        final confirmedWorker = {
                          "USERID": widget.worker["value"],
                          "WUSER": widget.worker["label"],
                          "WTEL": widget.worker["tel"],
                          "signPath": filePath,
                          "educationList": checkedItems,
                        };

                        print("🎯 confirmedWorker 생성됨: $confirmedWorker");
                        Navigator.of(context).pop(confirmedWorker);
                      }
                    } else {
                      _showAlert(context);
                    }
                  },

                  child: const Text(
                    "서명 완료",
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTag(String category) {
    Color backgroundColor;
    Color textColor = Colors.white;
    double borderRadius = 8.0;

    switch (category) {
      case "PBS":
        backgroundColor = const Color.fromRGBO(255, 114, 173, 1);
        break;
      case "PSM":
        backgroundColor = const Color.fromRGBO(114, 207, 255, 1);
        break;
      case "교육":
        backgroundColor = const Color.fromRGBO(8, 69, 152, 1);
        break;
      case "법령":
        backgroundColor = const Color.fromRGBO(211, 84, 0, 1);
        break;
      case "작업교육":
        backgroundColor = const Color(0xFF33CCC3);
        break;
      default:
        backgroundColor = Colors.grey;
        textColor = Colors.black;
        borderRadius = 5.0;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        category,
        style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }

  void _showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("교육 체크 필요"),
          content: const Text("모든 교육 항목을 체크해야 서명할 수 있습니다."),
          actions: [
            TextButton(
              child: const Text("확인"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
