import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smartsafety_light_app/providers/work_list_provider.dart';
import 'package:smartsafety_light_app/screens/login_screen.dart';
import 'package:smartsafety_light_app/providers/sinmungo_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/env/.env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkListProvider()),
        ChangeNotifierProvider(create: (_) => SinmungoProvider()),
      ],
      child: const MyApp(),
    ),
  );}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '스마트 안전 관리 시스템',
      theme: ThemeData(
        fontFamily: "Pretendard",
      ),
      home: LoginScreen(), // 초기 화면
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ko', 'KR'),
      ],
    );
  }
}