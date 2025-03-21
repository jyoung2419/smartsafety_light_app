// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/work_list_provider.dart';
// import '../work_list/work_card.dart';
// import '../work_list/category_wstate_danger_widget.dart';
//
// class WorkHisListWidget extends StatefulWidget {
//   const WorkHisListWidget({super.key});
//
//   @override
//   State<WorkHisListWidget> createState() => _WorkHisListWidgetState();
// }
//
// class _WorkHisListWidgetState extends State<WorkHisListWidget> {
//   int category = 0;
//   late ScrollController _scrollController;
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//     Future.microtask(() {
//       context.read<WorkListProvider>().fetchCompletedWorkList(dstate: category);
//     });
//   }
//
//   void onPressDstate(int dstate) {
//     context.read<WorkListProvider>().fetchCompletedWorkList(dstate: dstate);
//     setState(() => category = dstate);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final workList = context.watch<WorkListProvider>().completedWorkList;
//
//     return Stack(
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(top: 140),
//           child: ListView.builder(
//             controller: _scrollController,
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             itemCount: workList.length,
//             itemBuilder: (context, index) {
//               final item = workList[index];
//               return GestureDetector(
//                 onTap: () => context.read<WorkListProvider>().fetchCompletedWorkDetail(item.wnum),
//                 child: WorkCard(
//                   work: item,
//                   isComplete: true,
//                 ),
//               );
//             },
//           ),
//         ),
//         Container(
//           padding: const EdgeInsets.all(10),
//           width: double.infinity,
//           color: const Color(0xFFF2F2F2),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     '위험 등급',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     '총 ${workList.length}건',
//                     style: const TextStyle(fontSize: 16, color: Colors.grey),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               CategoryWstateDangerWidget(
//                 category: category,
//                 categoryWState: 0,
//                 onCategoryChanged: (dstate, _) => onPressDstate(dstate),
//               ),
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }
