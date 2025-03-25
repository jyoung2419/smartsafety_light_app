import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../providers/sinmungo_provider.dart';
import 'take_action_completed_widget.dart';

class SinmungoTakeActionWidget extends StatefulWidget {
  final Map<String, dynamic> sinmungo;
  const SinmungoTakeActionWidget({super.key, required this.sinmungo});

  @override
  State<SinmungoTakeActionWidget> createState() => _SinmungoTakeActionWidgetState();
}

class _SinmungoTakeActionWidgetState extends State<SinmungoTakeActionWidget> {
  final _causeController = TextEditingController();
  final _measureController = TextEditingController();
  final _relapseController = TextEditingController();
  final _etcController = TextEditingController();
  final List<File> _images = [];
  final List<int> _selectedCodes = [];
  DateTime? _repairDate;

  @override
  void initState() {
    super.initState();
    Provider.of<SinmungoProvider>(context, listen: false).fetchActionCodes();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() => _images.add(File(picked.path)));
    }
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

  void _submit() async {
    final data = {
      'IDX': widget.sinmungo['IDX'],
      'REPAIR_CAUSE': _causeController.text,
      'REPAIR_MEASURE': _measureController.text,
      'REPAIR_RELAPSE': _relapseController.text,
      'REPAIR_DESCR': _selectedCodes,
      'REPAIR_ETC_CONTENT': _etcController.text,
      'REPAIR_DATE': _repairDate != null
          ? _repairDate!.toIso8601String().split('T')[0]
          : DateTime.now().toIso8601String().split('T')[0],
    };

    await Provider.of<SinmungoProvider>(context, listen: false).takeAction(data, _images);
    await Provider.of<SinmungoProvider>(context, listen: false).fetchSinmungoDetail(widget.sinmungo['IDX'].toString());

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final actionCodes = Provider.of<SinmungoProvider>(context).actionCodes;
    final sinmungo = widget.sinmungo;
    final isCompleted = (sinmungo['REPAIR_DATE'] != null && sinmungo['REPAIR_DATE'].toString().isNotEmpty);

    if (isCompleted) {
      return SinmungoTakeActionCompletedWidget(sinmungo: sinmungo);
    }

    return Padding(
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
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
          const Text('발생원인', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          _buildInputField(_causeController, '발생원인을 입력하세요'),
          const SizedBox(height: 10),
          const Text('재발방지대책', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          _buildInputField(_measureController, '재발방지대책을 입력하세요'),
          const SizedBox(height: 10),
          const Text('조치사항', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          _buildInputField(_relapseController, '조치사항을 입력하세요'),
          const SizedBox(height: 16),
          const Text('개선유형', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF2980BA))),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ...actionCodes.map((code) {
                final isSelected = _selectedCodes.contains(code['SAFETY_CD']);
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.43,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isSelected
                            ? _selectedCodes.remove(code['SAFETY_CD'])
                            : _selectedCodes.add(code['SAFETY_CD']);
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

              // 기타 항목
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedCodes.contains(16)
                              ? _selectedCodes.remove(16)
                              : _selectedCodes.add(16);
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            _selectedCodes.contains(16) ? Icons.check_box : Icons.check_box_outline_blank,
                            size: 20,
                            color: const Color(0xFF2980BA),
                          ),
                          const SizedBox(width: 6),
                          const Text('기타', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                    if (_selectedCodes.contains(16))
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
          const Text('사진 등록'),
          Wrap(
            spacing: 8,
            children: _images.map((img) => Image.file(img, width: 100, height: 100)).toList(),
          ),
          ElevatedButton(
            onPressed: _pickImage,
            child: const Text('사진 촬영'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('조치 등록'),
          )
        ],
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 14),
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
