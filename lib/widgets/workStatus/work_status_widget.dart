import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WorkStatusWidget extends StatelessWidget {
  final int waiting;      // 작업 대기
  final int inProgress;   // 작업 중
  final int completed;    // 완료

  const WorkStatusWidget({
    super.key,
    required this.waiting,
    required this.inProgress,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                "assets/svg/home/backgroundImgOne.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "작업 현황",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: _buildStatusBox("작업 대기", waiting, "assets/svg/workAll.svg", width: 15, height: 15),
                    ),
                    _buildDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: _buildStatusBox("작업 중", inProgress, "assets/svg/working.svg", width: 10, height: 10),
                    ),
                    _buildDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: _buildStatusBox("완료", completed, "assets/svg/workSuccess.svg", width: 15, height: 15),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBox(String title, int count, String svgPath, {double width = 15, double height = 15}) {
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset(
              svgPath,
              width: width,
              height: height,
              color: Colors.white,
            ),
            const SizedBox(width: 5),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 60,
      width: 1,
      color: Colors.white
    );
  }
}
