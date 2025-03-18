import 'package:flutter/material.dart';
import './screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '스마트 안전 관리 시스템',
      theme: ThemeData(
          fontFamily: "Pretendard"
      ),
      home: HomeScreen(), // 초기 화면
    );
  }
}