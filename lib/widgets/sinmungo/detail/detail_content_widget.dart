import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/sinmungo_provider.dart';
import 'sinmungo_checkbox_list_widget.dart';

class SinmungoDetailContentWidget extends StatefulWidget {
  final Map<String, dynamic> sinmungo;
  final List<Map<String, dynamic>> imgList;

  const SinmungoDetailContentWidget({
    super.key,
    required this.sinmungo,
    required this.imgList,
  });

  @override
  State<SinmungoDetailContentWidget> createState() => _SinmungoDetailContentWidgetState();
}

class _SinmungoDetailContentWidgetState extends State<SinmungoDetailContentWidget> {
  @override
  void initState() {
    super.initState();
    Provider.of<SinmungoProvider>(context, listen: false).fetchReportCodes();
  }

  @override
  Widget build(BuildContext context) {
    final sinmungo = widget.sinmungo;
    final imgList = widget.imgList;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '신고 내용',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFC0392B)),
          ),
          const SizedBox(height: 6),
          const Text(
            '안전신문고 정보',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFC0392B)),
          ),
          const SizedBox(height: 6),
          _buildTextRow('신고 내용', sinmungo['REPORT_CONTENT'] ?? ''),
          _buildTextRow('구분', sinmungo['IMPO_TYPE'] == '1' ? '일반' : '긴급'),
          _buildTextRow('발생일자', sinmungo['REPORT_DATE'] ?? ''),
          _buildTextRow('발생위치', sinmungo['POSITION'] ?? ''),
          const SizedBox(height: 10),
          const Text('발생유형', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFFC0392B))),
          SinmungoCheckboxListWidget(sinmungo: sinmungo),
          const SizedBox(height: 5),
          const Text('사진', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFFC0392B))),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: imgList
                  .where((img) => img['TYPE'] == 1)
                  .map((img) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Image.network(
                  img['PATH'],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 100,
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: const Text(
                        '서버에서 사진을 가져올 수 없습니다.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    );
                  },
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$title:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text( value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}