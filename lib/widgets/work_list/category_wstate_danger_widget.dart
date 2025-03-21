import 'package:flutter/material.dart';

class CategoryWstateDangerWidget extends StatelessWidget {
  final int category;
  final int? categoryWState;
  final Function(int dstate, [int? wstate]) onCategoryChanged;
  final double height;

  const CategoryWstateDangerWidget({
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
        _buildCategoryButton("전체", 0, category, categoryWState, '#575ceb'),
        _buildCategoryButton("고위험", 1, category, categoryWState, '#EB5757'),
        _buildCategoryButton("위험", 2, category, categoryWState, '#F2994A'),
        _buildCategoryButton("일반", 3, category, categoryWState, '#27AE60'),
      ],
    );
  }

  Widget _buildCategoryButton(
      String label,
      int value,
      int selected,
      int? wstate,
      String colorHex,
      ) {
    final bool isSelected = value == selected;
    final Color selectedColor = HexColor.fromHex(colorHex);
    final Color backgroundColor = isSelected ? selectedColor : Colors.white;
    final Color textColor = isSelected ? Colors.white : selectedColor;

    return Expanded(
      child: GestureDetector(
        onTap: () => onCategoryChanged(value, wstate),
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
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
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
