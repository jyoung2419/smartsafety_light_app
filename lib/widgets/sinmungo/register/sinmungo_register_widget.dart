import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../providers/sinmungo_provider.dart';
import '../sinmungo_photo_upload_widget.dart';
import '../../../screens/sinmungo/sinmungo_screen.dart';

class SinmungoRegisterWidget extends StatefulWidget {
  final Map<String, dynamic> sinmungo;
  final List<Map<String, dynamic>> imgList;

  const SinmungoRegisterWidget({super.key, required this.sinmungo, required this.imgList});

  @override
  State<SinmungoRegisterWidget> createState() => _SinmungoRegisterWidgetState();
}

class _SinmungoRegisterWidgetState extends State<SinmungoRegisterWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _etcController = TextEditingController();
  final List<String> _selectedDescr = [];
  DateTime? _selectedDate;
  int _impoType = 1;  // 기본값
  List<File> _pickedImages = [];

  @override
  void initState() {
    super.initState();
    _contentController.text = widget.sinmungo['REPORT_CONTENT'] ?? '';
    _positionController.text = widget.sinmungo['POSITION'] ?? '';
    _selectedDate = widget.sinmungo['REPORT_DATE'] != null
        ? DateTime.tryParse(widget.sinmungo['REPORT_DATE'])
        : null;
    _impoType = int.tryParse(widget.sinmungo['IMPO_TYPE'] ?? '1') ?? 1;
  }

  Future<void> _selectReportDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (_selectedDescr.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('경고'),
          content: const Text('발생유형을 선택해주세요.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        ),
      );
      return;
    }

    if (_selectedDate == null) {
      _selectedDate = DateTime.now();
    }

    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('loginUserId') ?? 'unknown';

    final data = {
      'IMPO_TYPE': _impoType.toString(),
      'POSITION': _positionController.text,
      'REPORT_USER': userId,
      'REPORT_DATE': _formatDateForDB(_selectedDate!),
      'REPORT_CONTENT': _contentController.text,
      'REPORT_DESCR': _selectedDescr.join(','),
      'REPORT_ETC_CONTENT': _etcController.text,
    };

    print("📦 신고 등록 데이터: ${jsonEncode(data)}");
    await Provider.of<SinmungoProvider>(context, listen: false).registerSinmungo(data, _pickedImages);

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('등록 완료'),
        content: const Text('신고가 성공적으로 등록되었습니다.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const SinmungoScreen(),
                ),
              );
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  String _formatDateForDB(DateTime date) {
    return "${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final actionCodes = Provider.of<SinmungoProvider>(context).reportCodes;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('신고 내용', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          _buildInputField(_contentController, '신고 내용을 입력하세요', maxLines: 3),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('구분', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Radio(
                    value: 1,
                    groupValue: _impoType,
                    activeColor: const Color(0xFFC0392B),
                    onChanged: (val) => setState(() => _impoType = val!),
                  ),
                  const Text('일반'),
                  SizedBox(width: 16),
                  Radio(
                    value: 2,
                    groupValue: _impoType,
                    activeColor: const Color(0xFFC0392B),
                    onChanged: (val) => setState(() => _impoType = val!),
                  ),
                  const Text('긴급'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('발생일자', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () => _selectReportDate(context),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC0392B),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    _selectedDate != null
                        ? "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}"
                        : "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('발생위치', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: _buildInputField(_positionController, '발생위치를 입력하세요'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('발생유형', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFC0392B))),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ...actionCodes.map((code) {
                final codeStr = code['SAFETY_CD'].toString();
                final isSelected = _selectedDescr.contains(codeStr);
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.43,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isSelected ? _selectedDescr.remove(codeStr) : _selectedDescr.add(codeStr);
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                          size: 20,
                          color: const Color(0xFFC0392B),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            code['SAFETY_NAME'],
                            style: TextStyle(
                              fontSize: code['SAFETY_NAME'].toString().length >= 10 ? 13 : 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedDescr.contains('9')
                              ? _selectedDescr.remove('9')
                              : _selectedDescr.add('9');
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            _selectedDescr.contains('9') ? Icons.check_box : Icons.check_box_outline_blank,
                            size: 20,
                            color: const Color(0xFFC0392B),
                          ),
                          const SizedBox(width: 6),
                          const Text('기타', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                    if (_selectedDescr.contains('9'))
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: _buildMultilineInputField(_etcController, '기타 내용을 입력하세요'),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SinmungoPhotoUploadWidget(
            mode: "register",
            isEditable: true,
            initialImages: _pickedImages,
            onImageSelected: (files) {
              setState(() {
                _pickedImages = files;
              });
            },
          ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width, // 버튼 너비 조절
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF33CCC3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  '등록',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String hintText, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$hintText';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 14),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: maxLines > 1 ? 20 : 10,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildMultilineInputField(TextEditingController controller, String hintText) {
    return TextFormField(
      controller: controller,
      maxLines: 3,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '내용을 입력해주세요';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
