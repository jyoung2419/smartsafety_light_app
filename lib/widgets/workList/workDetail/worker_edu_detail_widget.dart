import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/work_list_provider.dart';

class WorkerEduDetailWidget extends StatefulWidget {
  final Map<String, dynamic> worker;

  const WorkerEduDetailWidget({super.key, required this.worker});

  @override
  State<WorkerEduDetailWidget> createState() => _WorkerEduDetailWidgetState();
}

class _WorkerEduDetailWidgetState extends State<WorkerEduDetailWidget> {
  @override
  void initState() {
    super.initState();
    final wnum = widget.worker['work_idx']?.toString();
    if (wnum != null && wnum.isNotEmpty) {
      context.read<WorkListProvider>().fetchEducationDetail(wnum);
      context.read<WorkListProvider>().fetchSign(wnum);
    } else {
      debugPrint("❌ 유효하지 않은 WNUM: ${widget.worker}");
    }
  }

  Widget _buildCategoryTag(String category) {
    Color backgroundColor;
    Color textColor = Colors.white;

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
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        category,
        style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkListProvider>();
    final signPath = provider.signData?['SIGN_PATH'];

    return Scaffold(
      appBar: AppBar(title: const Text('작업자 교육 상세')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("교육 내역", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFF2994A))),
            const SizedBox(height: 10),

            Expanded(
              child: provider.educationList.isEmpty
                  ? const Center(child: Text("교육 내역이 없습니다.", style: TextStyle(fontSize: 14)))
                  : ListView.builder(
                itemCount: provider.educationList.length,
                itemBuilder: (_, index) {
                  final item = provider.educationList[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        _buildCategoryTag(item['GUBUN_NAME'] ?? ''),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(item['INFO_DESCR'] ?? '', style: const TextStyle(fontSize: 13)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),
            const Text("서명 이미지", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF33CCC3))),
            const SizedBox(height: 10),

            if (signPath != null)
              Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Image.network(
                  signPath,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Center(child: Text("서명 이미지 로드 실패")),
                ),
              )
            else
              const Text("서명 정보가 없습니다.", style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}