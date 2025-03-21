import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/work_list_provider.dart';

class WorkDetailWidget extends StatelessWidget {
  const WorkDetailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final detail = context.watch<WorkListProvider>().workDetail;

    if (detail == null) return SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("작업 상세", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text("작업번호: ${detail['WNUM']}"),
          Text("작업명: ${detail['WORK_NAME']}"),
          Text("작업자: ${detail['WORKER_NAME']}"),
          Text("상태: ${detail['STATUS']}"),
          // 필요한 필드 추가
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () => context.read<WorkListProvider>().hideDetail(),
              child: const Text("닫기"),
            ),
          ),
        ],
      ),
    );
  }
}
