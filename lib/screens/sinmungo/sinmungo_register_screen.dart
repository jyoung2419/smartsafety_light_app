import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/sinmungo_provider.dart';
import '../../widgets/header.dart';
import '../../widgets/sinmungo/register/sinmungo_register_widget.dart';

class SinmungoRegisterScreen extends StatelessWidget {
  const SinmungoRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SinmungoProvider>(context);
    provider.fetchReportCodes();
    final registerData = {
      'REPORT_CONTENT': '',
      'IMPO_TYPE': '1',
      'REPORT_DATE': '',
      'POSITION': '',
      'REPORT_DESCR': [],
      'REPORT_ETC_CONTENT': '',
      'imgList': [],
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Column(
          children: [
            const Header(title: "안전신문고 등록", backgroundColor: Color(0xFFF2F2F2)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SinmungoRegisterWidget(
                  sinmungo: registerData,
                  imgList: const [],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
