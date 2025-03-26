import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/secure_storage_util.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _userPwController = TextEditingController();
  final storage = const FlutterSecureStorage();

  bool _isLoading = false;

  void _checkAutoLogin() async {
    String? token = await SecureStorageUtil.getToken();
    if (token != null) {
      _navigateToHome();
    }
  }

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final String userId = _userIdController.text.trim();
    final String userPw = _userPwController.text.trim();

    if (userId.isEmpty || userPw.isEmpty) {
      _showErrorDialog("아이디와 비밀번호를 입력하세요.");
      setState(() => _isLoading = false);
      return;
    }

    final String hashedPw = sha256.convert(utf8.encode(userPw)).toString();

    final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
    final String port = dotenv.env['PORT'] ?? '3000';
    final Uri url = Uri.parse('$baseUrl:$port/smartSafetyLogin');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": userId,
          "userPw": hashedPw,
          "pushToken": "default_push_token",
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isEmpty) {
          _showErrorDialog("로그인 실패: 아이디 또는 비밀번호가 올바르지 않습니다.");
          setState(() => _isLoading = false);
          return;
        }

        final Map<String, dynamic> userInfo = data.first;
        final String? token = userInfo['token'];

        if (token != null) {
          await SecureStorageUtil.saveToken(token);

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('loginUserId', userInfo['USERID']);
          await prefs.setString('loginUserName', userInfo['USERNM']);
          await prefs.setString('loginUserTel', userInfo['TEL'] ?? "");

          _navigateToHome();
        } else {
          _showErrorDialog("로그인 실패: 서버에서 토큰을 제공하지 않았습니다.");
        }
      } else {
        _showErrorDialog("로그인 실패: 서버 응답 오류 (${response.statusCode})\n${response.body}");
      }
    } catch (error) {
      _showErrorDialog("로그인 실패: 네트워크 오류.");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("로그인 오류"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 270,
                color: const Color(0xFF33CCC3),
              ),
              Positioned.fill(
                child: Opacity(
                  opacity: 0.5,
                  child: SvgPicture.asset(
                    'assets/svg/home/pattern.svg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 80,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "스마트 안전 관리 시스템",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Nextcare Safety 3D technology",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 70),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "SIGN UP",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        TextField(
                          controller: _userIdController,
                          decoration: InputDecoration(
                            hintText: "아이디를 입력하세요",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(color: Colors.black54),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _userPwController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "비밀번호를 입력하세요",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(color: Colors.black54),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF33CCC3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        "로그인",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Copyright (c) 2021 NextcoreTechnology\nAll right reserved.",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
