import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class WorkInfoAddWidget extends StatefulWidget {
  final Function(String) onWorkNameChange;
  final Function(DateTime) onStartDateChange;
  final Function(DateTime) onEndDateChange;
  final Function(String) onWorkPlaceChange;
  final Function(String) onWorkContentChange;
  final Function(Map<String, dynamic>) onSubmitWork; // 작업 승인 요청 시 호출

  const WorkInfoAddWidget({
    super.key,
    required this.onWorkNameChange,
    required this.onStartDateChange,
    required this.onEndDateChange,
    required this.onWorkPlaceChange,
    required this.onWorkContentChange,
    required this.onSubmitWork,
  });

  @override
  _WorkInfoAddWidgetState createState() => _WorkInfoAddWidgetState();
}

class _WorkInfoAddWidgetState extends State<WorkInfoAddWidget> {
  TextEditingController workNameController = TextEditingController();
  TextEditingController workPlaceController = TextEditingController();
  TextEditingController workContentController = TextEditingController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  Future<void> _selectDateTime(BuildContext context, bool isStart) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStart ? startDate : endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(isStart ? startDate : endDate),
    );

    if (pickedTime == null) return;

    final DateTime pickedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      if (isStart) {
        startDate = pickedDateTime;
        widget.onStartDateChange(pickedDateTime);
      } else {
        endDate = pickedDateTime;
        widget.onEndDateChange(pickedDateTime);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: const Color(0xFF2D9CDB), width: 1),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "작업 정보",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D9CDB)),
          ),
          const SizedBox(height: 10),

          _buildTitleWithIcon("작업명", "assets/svg/work/workName.svg", const Color(0xFF2D9CDB)),
          _buildInputField(workNameController, "작업명을 입력하세요", (value) {
            widget.onWorkNameChange(value);
          }),

          _buildTitleWithIcon("작업시간", "assets/svg/calendar_solid.svg", const Color(0xFF2D9CDB)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDatePicker(context, startDate, true),
              const Text("~", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D9CDB))),
              _buildDatePicker(context, endDate, false),
            ],
          ),

          const SizedBox(height: 15),

          _buildTitleWithIcon("작업 장소", "assets/svg/work/location.svg", const Color(0xFF2D9CDB)),
          _buildInputField(workPlaceController, "장소를 입력하세요", (value) {
            widget.onWorkPlaceChange(value);
          }),

          _buildTitleWithIcon("작업 내용", "assets/svg/work/workContent.svg", const Color(0xFF2D9CDB)),
          _buildMultilineInputField(workContentController, "작업 내용을 입력하세요", (value) {
            widget.onWorkContentChange(value);
          }),
        ],
      ),
    );
  }

  Widget _buildTitleWithIcon(String title, String iconPath, Color color) {
    return Row(
      children: [
        SvgPicture.asset(iconPath, width: 15, height: 15, color: color),
        const SizedBox(width: 5),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D9CDB)),
        ),
      ],
    );
  }

  Widget _buildInputField(TextEditingController controller, String hintText, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 10),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
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
      ),
    );
  }

  Widget _buildMultilineInputField(TextEditingController controller, String hintText, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 10),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
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
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, DateTime selectedDate, bool isStart) {
    return GestureDetector(
      onTap: () => _selectDateTime(context, isStart),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey.shade400, width: 1),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Text(
              DateFormat('yyyy. MM. dd HH:mm').format(selectedDate),
              style: const TextStyle(fontSize: 13, color: Colors.black),
            ),
            const SizedBox(width: 5),
            SvgPicture.asset("assets/svg/calendar_solid.svg", width: 16, height: 16, color: Color(0xFF2D9CDB)),
          ],
        ),
      ),
    );
  }
}
