import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/sinmungo_model.dart';
import '../../../providers/sinmungo_provider.dart';
import '../../screens/sinmungo/sinmungo_detail_screen.dart';

class SinmungoCardWidget extends StatelessWidget {
  final SinmungoModel sinmungo;
  const SinmungoCardWidget({super.key, required this.sinmungo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // 상세 데이터 요청
        await context.read<SinmungoProvider>().fetchSinmungoDetail(sinmungo.idx.toString());

        // 화면 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SinmungoDetailScreen(
              idx: sinmungo.idx,
              preloadedData: sinmungo.toJson(),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFDCDCDC), width: 0.5),
          borderRadius: BorderRadius.circular(4),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(1, 1),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 80,
                  child: Row(
                    children: [
                      Text('등록일시', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(' | '),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        sinmungo.regDate,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Row(
                        children: [
                          _buildBadge(
                            sinmungo.impoType == '1' ? '일반' : '긴급',
                            color: sinmungo.impoType == '1' ? Color(0xFFF8D726) : Color(0xFFD25200),
                          ),
                          const Text(' / '),
                          _buildBadge(
                            sinmungo.repairState,
                            color: sinmungo.repairState == '조치중' ? Color(0xFFF8D726) : Color(0xFF7F7F7F),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildRow('신고내용', sinmungo.reportContent),
            const SizedBox(height: 10),
            _buildRow('발생장소', sinmungo.position),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Row(
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Text(' | '),
            ],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String label, {required Color color}) {
    return Container(
      width: 50,
      padding: const EdgeInsets.symmetric(vertical: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
