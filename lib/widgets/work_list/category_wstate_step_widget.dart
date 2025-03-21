import 'package:flutter/material.dart';

class CategoryWstateStepWidget extends StatelessWidget {
  final int category;
  final int? categoryWState;
  final Function(int dstate, [int? wstate]) onCategoryChanged;
  final double height;

  const CategoryWstateStepWidget({
    super.key,
    required this.category,
    this.categoryWState,
    required this.onCategoryChanged,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStepButton("전체", 0),
        _buildStepButton("승인대기", 1),
        _buildStepButton("작업중", 3),
        _buildStepButton("작업 완료\n대기", 4, fontSize: 13, multiline: true),
      ],
    );
  }

  Widget _buildStepButton(String label, int value, {double fontSize = 16, bool multiline = false}) {
    final bool isSelected = value == categoryWState;
    final Color selectedColor = HexColor.fromHex('#575ceb');
    final Color backgroundColor = isSelected ? selectedColor : Colors.white;
    final Color textColor = isSelected ? Colors.white : selectedColor;

    return Expanded(
      child: GestureDetector(
        onTap: () => onCategoryChanged(category, value),
        child: Container(
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: selectedColor),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              height: multiline ? 1.4 : 1.0,
            ),
          ),
        ),
      ),
    );
  }
}

class HexColor extends Color {
  HexColor(final int hexColor) : super(hexColor);

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
