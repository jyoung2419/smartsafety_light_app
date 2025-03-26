import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../providers/sinmungo_provider.dart';
import '../../../screens/sinmungo/sinmungo_screen.dart';
import '../sinmungo_photo_upload_widget.dart';
import 'take_action_completed_widget.dart';

class SinmungoTakeActionWidget extends StatefulWidget {
  final Map<String, dynamic> sinmungo;
  const SinmungoTakeActionWidget({super.key, required this.sinmungo});

  @override
  State<SinmungoTakeActionWidget> createState() => _SinmungoTakeActionWidgetState();
}

class _SinmungoTakeActionWidgetState extends State<SinmungoTakeActionWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _causeController = TextEditingController();
  final TextEditingController _measureController = TextEditingController();
  final TextEditingController _relapseController = TextEditingController();
  final TextEditingController _etcController = TextEditingController();
  final List<String> _selectedCodes = [];
  List<File> _pickedImages = [];
  DateTime? _repairDate;

  @override
  void initState() {
    super.initState();
    _causeController.text = widget.sinmungo['REPAIR_CAUSE'] ?? '';
    _measureController.text = widget.sinmungo['REPAIR_MEASURE'] ?? '';
    _relapseController.text = widget.sinmungo['REPAIR_RELAPSE'] ?? '';
    _repairDate = widget.sinmungo['REPAIR_DATE'] != null
        ? DateTime.tryParse(widget.sinmungo['REPAIR_DATE'])
        : null;
  }

  Future<void> _selectRepairDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _repairDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _repairDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (_selectedCodes.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('경고'),
          content: const Text('개선유형을 선택해주세요.'),
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

    if (_repairDate == null) {
      _repairDate = DateTime.now();
    }
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('loginUserId') ?? 'unknown';
    final data = {
      'idx': widget.sinmungo['IDX'],
      'REPAIR_CAUSE': _causeController.text,
      'REPAIR_USER': userId,
      'REPAIR_DATE': _formatDateForDB(_repairDate!),
      'REPAIR_MEASURE': _measureController.text,
      'REPAIR_RELAPSE': _relapseController.text,
      'REPAIR_DESCR': _selectedCodes.join(','),
      'REPAIR_ETC_CONTENT': _etcController.text,
    };

    await Provider.of<SinmungoProvider>(context, listen: false).takeAction(data, _pickedImages);

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('등록 완료'),
        content: const Text('조치가 성공적으로 등록되었습니다.'),
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
    return "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final actionCodes = Provider.of<SinmungoProvider>(context).actionCodes;
    final sinmungo = widget.sinmungo;
    final isCompleted = (sinmungo['REPAIR_DATE'] != null && sinmungo['REPAIR_DATE'].toString().isNotEmpty);

    if (isCompleted) {
      return SinmungoTakeActionCompletedWidget(sinmungo: sinmungo);
    }

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('조치 등록', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2980BA))),
              const Text('안전신문고 조치 정보', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2980BA))),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    '조치일자',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => _selectRepairDate(context),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2980BA),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        _repairDate != null
                            ? "${_repairDate!.year}-${_repairDate!.month.toString().padLeft(2, '0')}-${_repairDate!.day.toString().padLeft(2, '0')}"
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
              const SizedBox(height: 10),
              const Text('발생원인', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              _buildInputField(_causeController),
              const SizedBox(height: 10),
              const Text('재발방지대책', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              _buildInputField(_measureController),
              const SizedBox(height: 10),
              const Text('조치사항', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              _buildInputField(_relapseController),
              const SizedBox(height: 16),
              const Text('개선유형', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2980BA))),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ...actionCodes.map((code) {
                    final codeStr = code['SAFETY_CD'].toString();
                    final isSelected = _selectedCodes.contains(codeStr);
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.43,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isSelected
                                ? _selectedCodes.remove(codeStr)
                                : _selectedCodes.add(codeStr);
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                              size: 20,
                              color: const Color(0xFF2980BA),
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
                              _selectedCodes.contains('16')
                                  ? _selectedCodes.remove('16')
                                  : _selectedCodes.add('16');
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                _selectedCodes.contains('16') ? Icons.check_box : Icons.check_box_outline_blank,
                                size: 20,
                                color: const Color(0xFF2980BA),
                              ),
                              const SizedBox(width: 6),
                              const Text('기타', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                            ],
                          ),
                        ),
                        if (_selectedCodes.contains('16'))
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
                mode: "false",
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
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF33CCC3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      '조치 등록',
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
      ),
    );
  }
  Widget _buildInputField(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
    return TextField(
      controller: controller,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
