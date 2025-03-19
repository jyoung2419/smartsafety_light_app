import 'package:flutter/material.dart';
import '../utils/secure_storage_util.dart';
import 'package:smartsafety_light_app/screens/login_screen.dart';

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
    final bool isHomeScreen = !Navigator.of(context).canPop();

    return Column(
      children: [
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          color: backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: isHomeScreen
                    ? const Icon(Icons.power_settings_new, color: Colors.white)
                    : const Icon(Icons.keyboard_arrow_left, color: Color(0xFF33CCC3),size: 30),
                onPressed: () {
                  if (isHomeScreen) {
                    _showLogoutDialog(context);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      color: isHomeScreen ? Colors.white : const Color(0xFF33CCC3),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isHomeScreen)
                    const SizedBox(height: 5),
                  if (isHomeScreen)
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
                icon: Icon(
                  Icons.menu,
                  color: isHomeScreen ? Colors.white : const Color(0xFF33CCC3),
                ),
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              "로그아웃",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          content: const Text(
            "로그아웃 하시겠습니까?",
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                "취소",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await SecureStorageUtil.deleteToken();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF33CCC3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                "확인",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
