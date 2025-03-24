import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/workList/work_list_widget.dart';
import '../widgets/workList/work_his_list_widget.dart';
import '../widgets/workList/workDetail/work_detail_widget.dart';
import '../widgets/header.dart';
import '../providers/work_list_provider.dart';

class WorkListScreen extends StatefulWidget {
  const WorkListScreen({super.key});

  @override
  State<WorkListScreen> createState() => _WorkListScreenState();
}

class _WorkListScreenState extends State<WorkListScreen> {
  int category = 0; // 0: 실시간 작업, 1: 완료 작업

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkListProvider>();
    final bool showDetail = provider.detailVisible;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const Header(
                  title: "작업 조회",
                  backgroundColor: Color(0xFFF2F2F2),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() => category = 0),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: category == 0
                                ? const Color(0xFF575CEB)
                                : Colors.white,
                            elevation: 5,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Text(
                            '실시간 작업',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: category == 0
                                  ? Colors.white
                                  : const Color(0xFF575CEB),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() => category = 1),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: category == 1
                                ? const Color(0xFF575CEB)
                                : Colors.white,
                            elevation: 5,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Text(
                            '완료 작업',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: category == 1
                                  ? Colors.white
                                  : const Color(0xFF575CEB),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: category == 0
                      ? const WorkListWidget()
                      : const WorkHisListWidget(),
                ),
              ],
            ),
            if (showDetail)
              const WorkDetailWidget(),
          ],
        ),
      ),
    );
  }
}
