import 'package:flutter/material.dart';
import '../../models/sinmungo_model.dart';
import 'sinmungo_card_widget.dart';

class CardListWidget extends StatelessWidget {
  final List<SinmungoModel> sinmungoList;
  const CardListWidget({super.key, required this.sinmungoList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sinmungoList.length,
      itemBuilder: (context, index) {
        final item = sinmungoList[index];
        return SinmungoCardWidget(sinmungo: item);
      },
    );
  }
}