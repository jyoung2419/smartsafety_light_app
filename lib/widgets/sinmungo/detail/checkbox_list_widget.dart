import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/sinmungo_provider.dart';

class SinmungoCheckboxListWidget extends StatelessWidget {
  final Map<String, dynamic> sinmungo;
  const SinmungoCheckboxListWidget({super.key, required this.sinmungo});

  @override
  Widget build(BuildContext context) {
    final reportCodes = Provider.of<SinmungoProvider>(context).reportCodes;
    final List<String> selectedCodes = List<String>.from(sinmungo['codeList'] ?? []);
    final reportEtcContent = sinmungo['REPORT_ETC_CONTENT'] ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          ...reportCodes.map((code) {
            final isSelected = selectedCodes.contains(code['SAFETY_CD'].toString());
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.43,
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                    size: 20,
                    color: const Color(0xFFC0392B),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      code['SAFETY_NAME'],
                      style: TextStyle(
                        fontSize: code['SAFETY_NAME'].toString().length >= 10 ? 13 : 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            );
          }).toList(),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      selectedCodes.contains('9') ? Icons.check_box : Icons.check_box_outline_blank,
                      size: 20,
                      color: const Color(0xFFC0392B),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '기타',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                if (selectedCodes.contains('9') && reportEtcContent.toString().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 4),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.1,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        reportEtcContent,
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
