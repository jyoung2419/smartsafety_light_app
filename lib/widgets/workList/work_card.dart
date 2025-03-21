import 'package:flutter/material.dart';
import '../../../models/live_work.dart';

class WorkCard extends StatelessWidget {
  final LiveWork work;
  final bool isComplete;

  const WorkCard({
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
        color: isComplete ? Colors.grey[200] : cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isComplete ? Colors.grey.shade400 : cardColor,
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
          Text('작업 상태: ${_getWstateText(work.wstate)}'),
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

  String _getWstateText(String code) {
    switch (code) {
      case '0': return '작업 승인 대기중';
      case '1': return '작업 시작 대기중';
      case '2': return '작업 중';
      case '3': return '작업 완료 대기';
      default: return '알 수 없음';
    }
  }

  /// 고위험/위험/일반 → 색상 지정
  Color _getDangerColor(String dangerState) {
    switch (dangerState) {
      case '1': return const Color(0xFFEB5757); // 고위험
      case '2': return const Color(0xFFF2994A); // 위험
      case '3': return const Color(0xFF27AE60); // 일반
      default:  return Colors.grey;             // 알 수 없음
    }
  }
}
