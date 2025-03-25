import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../providers/work_list_provider.dart';
import 'worker_edu_detail_widget.dart';

class WorkHisDetailWidget extends StatefulWidget {
  const WorkHisDetailWidget({super.key});

  @override
  State<WorkHisDetailWidget> createState() => _WorkHisDetailWidgetState();
}

class _WorkHisDetailWidgetState extends State<WorkHisDetailWidget> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<WorkListProvider>();
    final wnum = provider.workDetail?['WNUM']?.toString();
    if (wnum != null && wnum.isNotEmpty) {
      provider.fetchPhotoBefore(wnum);
      provider.fetchPhotoAfter(wnum);
    }
  }

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
    final provider = context.watch<WorkListProvider>();
    final detail = provider.workDetail;

    if (detail == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("완료 작업 상세", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D9CDB))),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF2D9CDB)),
                  onPressed: () => provider.hideDetail(),
                ),
              ],
            ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
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
                            OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => WorkerEduDetailWidget(worker: worker),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFF6A1B9A), width: 1),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              ),
                              child: const Text(
                                "상세보기",
                                style: TextStyle(
                                  color: Color(0xFF6A1B9A),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    })
                  else
                    const Text("작업자 정보 없음", style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
            _buildBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("작업 전 사진", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF27AE60))),
                  const SizedBox(height: 12),
                  if (provider.photoBeforeList.isNotEmpty)
                    SizedBox(
                      height: 180,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.photoBeforeList.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final photo = provider.photoBeforeList[index];
                          final imgPath = photo['IMAGE_PATH'];
                          return Container(
                            width: 280,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: imgPath != null
                                ? Image.network(imgPath, fit: BoxFit.cover)
                                : const Center(child: Text("이미지 없음")),
                          );
                        },
                      ),
                    )
                  else
                    const Text("작업 전 사진이 없습니다.", style: TextStyle(fontSize: 15)),
                ],
              ),
            ),

            _buildBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("작업 후 사진", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF27AE60))),
                  const SizedBox(height: 12),
                  if (provider.photoAfterList.isNotEmpty)
                    SizedBox(
                      height: 180,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.photoAfterList.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final photo = provider.photoAfterList[index];
                          final imgPath = photo['IMAGE_PATH'];
                          return Container(
                            width: 280,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: imgPath != null
                                ? Image.network(imgPath, fit: BoxFit.cover)
                                : const Center(child: Text("이미지 없음")),
                          );
                        },
                      ),
                    )
                  else
                    const Text("작업 후 사진이 없습니다.", style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
