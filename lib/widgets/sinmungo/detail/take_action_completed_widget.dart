import 'package:flutter/material.dart';
import 'take_action_checkbox_list_widget.dart';

class SinmungoTakeActionCompletedWidget extends StatelessWidget {
  final Map<String, dynamic> sinmungo;
  const SinmungoTakeActionCompletedWidget({super.key, required this.sinmungo});

  @override
  Widget build(BuildContext context) {
    final repairDate = sinmungo['REPAIR_DATE'] ?? '';
    final cause = sinmungo['REPAIR_CAUSE'] ?? '';
    final measure = sinmungo['REPAIR_MEASURE'] ?? '';
    final relapse = sinmungo['REPAIR_RELAPSE'] ?? '';
    final imgList = List<Map<String, dynamic>>.from(sinmungo['imgList'] ?? []);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('조치 완료', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2980BA))),
          const Text('안전신문고 조치 정보', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2980BA))),
          const SizedBox(height: 16),
          _buildTextRow('조치일자', repairDate),
          _buildTextRow('발생원인', cause),
          _buildTextRow('재발방지대책', measure),
          _buildTextRow('조치사항', relapse),
          const SizedBox(height: 10),
          const Text('개선유형', style: TextStyle(fontWeight: FontWeight.bold)),
          SinmungoTakeActionCheckboxListWidget(sinmungo: sinmungo),
          const SizedBox(height: 16),
          const Text('조치 사진', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: imgList
                  .where((img) => img['TYPE'] == 2)
                  .map((img) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Image.network(
                  img['PATH'],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _imageErrorWidget(context),
                ),
              ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _imageErrorWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 100,
      color: Colors.grey[300],
      alignment: Alignment.center,
      child: const Text('서버에서 사진을 가져올 수 없습니다.', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.black)),
    );
  }
}
