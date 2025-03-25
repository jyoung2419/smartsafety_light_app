import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/work_list_provider.dart';
import '../../../models/completed_work.dart';
import '../workList/work_his_card.dart';
import '../workList/category_wstate_danger_widget.dart';

class WorkHisListWidget extends StatefulWidget {
  const WorkHisListWidget({super.key});

  @override
  State<WorkHisListWidget> createState() => _WorkHisListWidgetState();
}

class _WorkHisListWidgetState extends State<WorkHisListWidget> {
  int category = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<WorkListProvider>().fetchCompletedWorkList(dstate: category);
    });
  }

  void onCategoryPressed(int dstate) {
    setState(() => category = dstate);
    context.read<WorkListProvider>().fetchCompletedWorkList(dstate: dstate);
  }

  @override
  Widget build(BuildContext context) {
    final workList = context.watch<WorkListProvider>().completedWorkList;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("위험 등급", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("총 ${workList.length}건", style: const TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
        ),
        CategoryWstateDangerWidget(
          category: category,
          onCategoryChanged: (int dstate, [int? _]) => onCategoryPressed(dstate),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: workList.length,
            itemBuilder: (context, index) {
              final item = workList[index];
              return GestureDetector(
                onTap: () {
                  context.read<WorkListProvider>().fetchCompletedWorkDetail(item.wnum);
                },
                child: WorkHisCard(
                  work: item,
                  isComplete: true,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
