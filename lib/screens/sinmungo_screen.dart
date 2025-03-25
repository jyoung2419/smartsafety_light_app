import 'package:flutter/material.dart';
import '../widgets/sinmungo/top_widget.dart';
import '../widgets/sinmungo/card_list_widget.dart';
import '../providers/sinmungo_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../widgets/header.dart';

class SinmungoScreen extends StatefulWidget {
  const SinmungoScreen({super.key});

  @override
  State<SinmungoScreen> createState() => _SinmungoScreenState();
}

class _SinmungoScreenState extends State<SinmungoScreen> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<SinmungoProvider>(context, listen: false);

    final fromDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 30)));
    final toDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    provider.fetchSinmungoList(
      fromDate: fromDate,
      toDate: toDate,
      state: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SinmungoProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Column(
          children: [
            const Header(
              title: "안전신문고",
              backgroundColor: Color(0xFFF2F2F2),
            ),
            TopWidget(),
            Expanded(
              child: CardListWidget(sinmungoList: provider.sinmungoList),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFFF2F2F2),
        padding: const EdgeInsets.all(5), // 여유 공간 추가 시
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/sinmungo/register');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF33CCC3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: const Text(
            '안전신문고 등록',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white
            ),
          ),
        ),
      )
    );
  }
}
