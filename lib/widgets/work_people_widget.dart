import 'package:flutter/material.dart';

class WorkPeopleWidget extends StatelessWidget {
  final int totalPeople;
  final int inProgressPeople;
  final int completedPeople;

  const WorkPeopleWidget({
    super.key,
    required this.totalPeople,
    required this.inProgressPeople,
    required this.completedPeople,
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
                "assets/svg/home/backgroundImgTwo.png",
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
                  "작업 인원",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildPeopleBox("투입 인원", totalPeople),
                    _divider(),
                    _buildPeopleBox("진행 중 인원", inProgressPeople),
                    _divider(),
                    _buildPeopleBox("완료 인원", completedPeople),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeopleBox(String title, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 60,
      color: Colors.white,
    );
  }
}
