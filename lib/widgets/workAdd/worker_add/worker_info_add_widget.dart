import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'worker_modal.dart';
import 'worker_edu_modal.dart';

class WorkerInfoAddWidget extends StatefulWidget {
  final Function() navigateToQRCode;
  final Function(List<Map<String, dynamic>>) onWorkerConfirmed;

  const WorkerInfoAddWidget({
    super.key,
    required this.navigateToQRCode,
    required this.onWorkerConfirmed,
  });

  @override
  _WorkerInfoAddWidgetState createState() => _WorkerInfoAddWidgetState();
}

class _WorkerInfoAddWidgetState extends State<WorkerInfoAddWidget> {
  List<Map<String, dynamic>> workers = [];

  void openWorkerModal() async {
    final confirmedWorker = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return WorkerModal(
          onWorkerSelected: (_) {},
        );
      },
    );

    if (confirmedWorker != null) {
      print("✅ 교육 완료: $confirmedWorker");

      setState(() {
        workers.add(confirmedWorker);
      });

      widget.onWorkerConfirmed(workers);
    }
  }

  void openWorkerEduModal(Map<String, dynamic> worker) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WorkerEduModal(
          worker: worker,
          closeModal: () => Navigator.of(context).pop(),
          onConfirm: (confirmedWorker) {
            print("✅ 교육 완료: $confirmedWorker");

            setState(() {
              workers.add(confirmedWorker);
            });

            widget.onWorkerConfirmed(workers); // ✅ 전체 workers 리스트 전달
          },
        );
      },
    );
  }

  void removeWorker(String targetId) {
    setState(() {
      workers.removeWhere((worker) => worker["WORKERID"] == targetId);
      widget.onWorkerConfirmed(workers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.orange, width: 1),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "작업자 정보",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionButton("선택하기", openWorkerModal),
              _buildActionButton("QR코드 촬영", widget.navigateToQRCode),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              SvgPicture.asset("assets/svg/work/partner.svg", width: 20, height: 20),
              const SizedBox(width: 5),
              const Text(
                "작업자",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF2D9CDB)),
              ),
              const SizedBox(width: 5),
              Text(
                "${workers.length}명",
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF2D9CDB)),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Column(
            children: workers.map((worker) {
              return _buildWorkerCard(worker);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkerCard(Map<String, dynamic> worker) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.shade400, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                worker["WORKERNAME"],// 여기수정해야해
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                worker["TEL"],// 여기수정해야해
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),

          worker["signPath"] != null
              ? Image.file(File(worker["signPath"]), width: 50, height: 50, fit: BoxFit.cover)
              : const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),

          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => removeWorker(worker["WORKERID"]),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, Function() onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFF33CCC3), width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF33CCC3)),
      ),
    );
  }
}
