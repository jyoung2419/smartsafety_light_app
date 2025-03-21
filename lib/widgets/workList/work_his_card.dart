import 'package:flutter/material.dart';
import '../../../models/completed_work.dart';

class WorkHisCard extends StatelessWidget {
  final CompletedWork work;
  final bool isComplete;

  const WorkHisCard({
    super.key,
    required this.work,
    this.isComplete = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = _getDangerColor(work.dangerState);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isComplete ? cardColor : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isComplete ? cardColor : Colors.grey.shade400,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(work.wname, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('시작 시간: ${work.wstart}'),
          Text('종료 시간: ${work.wend}'),
          Text('작업 내용: ${work.wcontent}'),
          Text('작업 장소: ${work.wplace}'),
          Text('담당자: ${work.wuser}'),
          Text('연락처: ${work.wtel}'),
        ],
      ),
    );
  }

  Color _getDangerColor(String dangerState) {
    switch (dangerState) {
      case '1': return const Color(0xFFEB5757);
      case '2': return const Color(0xFFF2994A);
      case '3': return const Color(0xFF27AE60);
      default:  return Colors.grey;
    }
  }
}
