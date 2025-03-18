import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF33CCC3),
      body: Column(
        children: [
          const Header(
            title: "스마트 안전 관리 시스템",
            backgroundColor: Color(0xFF33CCC3),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: GestureDetector(
              onTap: () {},
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SvgPicture.asset(
                      'assets/svg/Mask.svg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/home/desktop.svg',
                          width: 40,
                          height: 40,
                        ),
                        const Text(
                          "작업 현황 모니터링",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF33CCC3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                children: [
                  Positioned(
                    top: screenHeight * 0.01,
                    left: 0,
                    child: _buildHomeButton(
                      context,
                      "작업등록",
                      "assets/svg/pen.svg",
                      "assets/img/MaskGroup.png",
                      screenWidth,
                      screenHeight * 0.23,
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.01,
                    right: 0,
                    child: _buildHomeButton(
                      context,
                      "작업 조회",
                      "assets/svg/cameraList.svg",
                      "assets/img/MaskGroup_5.png",
                      screenWidth,
                      screenHeight * 0.185,
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.26,
                    left: 0,
                    child: _buildHomeButton(
                      context,
                      "위험성\n평가",
                      "assets/svg/chart-line.svg",
                      "assets/img/MaskGroup_2.png",
                      screenWidth,
                      screenHeight * 0.2,
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.21,
                    right: 0,
                    child: _buildHomeButton(
                      context,
                      "안전\n신문고",
                      "assets/svg/bullhorn.svg",
                      "assets/img/MaskGroup9.png",
                      screenWidth,
                      screenHeight * 0.2,
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.48,
                    left: 0,
                    child: _buildHomeButton(
                      context,
                      "BP사 조회",
                      "assets/svg/buildings.svg",
                      "assets/img/MaskGroup_4.png",
                      screenWidth,
                      screenHeight * 0.165,
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.43,
                    right: 0,
                    child: _buildHomeButton(
                      context,
                      "출입관리",
                      "assets/svg/address-card.svg",
                      "assets/img/MaskGroup_11.png",
                      screenWidth,
                      screenHeight * 0.215,
                      isDialog: true,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: const Text(
              "Copyright (c) 2023 NextcoreTechnology \nAll right reserved.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeButton(
      BuildContext context,
      String text,
      String iconPath,
      String bgImage,
      double screenWidth,
      double height, {
        bool isDialog = false,
      }) {
    return SizedBox(
      width: (screenWidth - 55) / 2,
      height: height,
      child: HomeButton(
        text: text,
        iconPath: iconPath,
        bgImage: bgImage,
        onTap: isDialog
            ? () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("알림"),
              content: const Text("준비 중 입니다"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("확인"),
                ),
              ],
            ),
          );
        }
            : () {},
      ),
    );
  }
}

class HomeButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final String bgImage;
  final VoidCallback onTap;

  const HomeButton({
    super.key,
    required this.text,
    required this.iconPath,
    required this.bgImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              image: DecorationImage(
                image: AssetImage(bgImage),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.white,
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: SvgPicture.asset(
              iconPath,
              width: 40,
              height: 40,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF33CCC3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
