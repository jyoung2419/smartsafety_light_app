import 'package:flutter/material.dart';

class WorkGradeWidget extends StatelessWidget {
  final int highRisk; // 고위험
  final int mediumRisk; // 위험
  final int lowRisk; // 일반

  const WorkGradeWidget({
    super.key,
    required this.highRisk,
    required this.mediumRisk,
    required this.lowRisk,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "작업 등급",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF33CCC3)),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildGradeBox("고위험", highRisk, "assets/svg/home/one.png"),
            _buildGradeBox("위험", mediumRisk, "assets/svg/home/two.png"),
            _buildGradeBox("일반", lowRisk, "assets/svg/home/three.png"),
          ],
        ),
      ],
    );
  }

  Widget _buildGradeBox(String title, int count, String imagePath) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 105,
          height: 105,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),

        Positioned(
          top: 20,
          child: Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        Positioned(
          bottom: 13,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}