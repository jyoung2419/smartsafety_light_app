import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  final Color backgroundColor;

  const Header({
    super.key,
    required this.title,
    this.backgroundColor = const Color(0xFF33CCC3),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 헤더 위 여백 추가 (10px)
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          color: backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Smart Safety Management System",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),

              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
