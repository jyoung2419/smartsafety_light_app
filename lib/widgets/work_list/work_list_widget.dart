import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/work_list_provider.dart';
import '../../models/live_work.dart';
import 'category_wstate_danger_widget.dart';
import 'category_wstate_step_widget.dart';
import 'work_card.dart';

class WorkListWidget extends StatefulWidget {
  const WorkListWidget({super.key});

  @override
  State<WorkListWidget> createState() => _WorkListWidgetState();
}

class _WorkListWidgetState extends State<WorkListWidget> {
  int category = 0;
  int categoryWState = 0;

  @override
  void initState() {
    super.initState();
    fetchList(category, categoryWState);
  }

  void fetchList(int dstate, int wstate) {
    final provider = context.read<WorkListProvider>();
    provider.fetchWorkList(dstate, wstate);
    setState(() {
      category = dstate;
      categoryWState = wstate;
    });
  }

  void onCategoryPressed(int dstate, int wstate) {
    fetchList(dstate, wstate);
  }

  @override
  Widget build(BuildContext context) {
    final rawList = context.watch<WorkListProvider>().workList;

    final workList = rawList.map((item) => LiveWork.fromJson(item)).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("위험 등급", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("총 ${workList.length}건", style: const TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
        ),
        CategoryWstateDangerWidget(
          category: category,
          categoryWState: categoryWState,
          onCategoryChanged: onCategoryPressed,
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text("작업 상태", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        CategoryWstateStepWidget(
          category: category,
          categoryWState: categoryWState,
          onCategoryChanged: onCategoryPressed,
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: workList.length,
            itemBuilder: (context, index) {
              final item = workList[index];
              return GestureDetector(
                onTap: () {
                  context.read<WorkListProvider>().fetchWorkDetail(item.wnum);
                },
                child: WorkCard(
                  work: item,
                  isComplete: false,
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
