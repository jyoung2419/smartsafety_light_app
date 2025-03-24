import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../providers/work_list_provider.dart';

class WorkHisDetailWidget extends StatelessWidget {
  const WorkHisDetailWidget({super.key});

  String getDangerText(String? code) {
    switch (code) {
      case '1':
        return '고위험';
      case '2':
        return '위험';
      case '3':
        return '일반';
      default:
        return '알 수 없음';
    }
  }

  String formatDateTime(String? raw) {
    if (raw == null || raw.length != 14) return '-';
    try {
      final formatted = "${raw.substring(0, 4)}-${raw.substring(4, 6)}-${raw.substring(6, 8)} "
          "${raw.substring(8, 10)}:${raw.substring(10, 12)}";
      return formatted;
    } catch (_) {
      return raw;
    }
  }

  Widget _buildTitleWithIcon(String title, String iconPath, Color color) {
    return Row(
      children: [
        SvgPicture.asset(iconPath, width: 15, height: 15, color: color),
        const SizedBox(width: 5),
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildBox({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final detail = context.watch<WorkListProvider>().workDetail;

    if (detail == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("완료 작업 상세", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D9CDB))),
            const SizedBox(height: 20),

            _buildBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("작업 종류 선택", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFFEB5757))),
                  const SizedBox(height: 12),

                  _buildTitleWithIcon("위험 등급", "assets/svg/work/danger.svg", const Color(0xFFEB5757)),
                  const SizedBox(height: 5),
                  Text(getDangerText(detail['DANGER_STATE']?.toString()), style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),

                  _buildTitleWithIcon("작업 종류", "assets/svg/work/danger.svg", const Color(0xFFEB5757)),
                  const SizedBox(height: 5),
                  Text(detail['DNAME'] ?? '없음', style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),

            _buildBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("작업 정보", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF2D9CDB))),
                  const SizedBox(height: 12),

                  _buildTitleWithIcon("작업명", "assets/svg/work/workName.svg", const Color(0xFF2D9CDB)),
                  const SizedBox(height: 5),
                  Text(detail['WNAME'] ?? '없음', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),

                  _buildTitleWithIcon("작업 시간", "assets/svg/calendar_solid.svg", const Color(0xFF2D9CDB)),
                  const SizedBox(height: 5),
                  Text(
                    "${formatDateTime(detail['WSTART'])} ~ ${formatDateTime(detail['WEND'])}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),

                  _buildTitleWithIcon("작업 장소", "assets/svg/work/location.svg", const Color(0xFF2D9CDB)),
                  const SizedBox(height: 5),
                  Text(detail['WPLACE'] ?? '없음', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),

                  _buildTitleWithIcon("작업 내용", "assets/svg/work/workContent.svg", const Color(0xFF2D9CDB)),
                  const SizedBox(height: 5),
                  Text(detail['WCONTENT'] ?? '없음', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),

                  _buildTitleWithIcon("등록자 ID", "assets/svg/user_solid.svg", const Color(0xFF2D9CDB)),
                  const SizedBox(height: 5),
                  Text(detail['USERID'] ?? '없음', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),

                  _buildTitleWithIcon("감독자 ID", "assets/svg/user_solid.svg", const Color(0xFF2D9CDB)),
                  const SizedBox(height: 5),
                  Text(detail['MUSER'] ?? '없음', style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),

            _buildBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("작업자 정보", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF6A1B9A))),
                  const SizedBox(height: 12),

                  if (detail['workManList'] != null && detail['workManList'] is List)
                    ...List.generate(detail['workManList'].length, (index) {
                      final worker = detail['workManList'][index];
                      final name = worker['USERNM'] ?? '이름 없음';
                      final company = worker['company_name'] ?? '소속 없음';
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.person, size: 20, color: Color(0xFF6A1B9A)),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name, style: const TextStyle(fontSize: 15)),
                                Text(company, style: const TextStyle(fontSize: 15)),
                              ],
                            ),
                          ],
                        ),
                      );
                    })
                  else
                    const Text("작업자 정보 없음", style: TextStyle(fontSize: 15)),
                ],
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => context.read<WorkListProvider>().hideDetail(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D9CDB),
                ),
                child: const Text("닫기", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
