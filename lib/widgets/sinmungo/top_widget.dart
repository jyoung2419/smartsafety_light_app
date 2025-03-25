import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../providers/sinmungo_provider.dart';
import 'package:provider/provider.dart';

class TopWidget extends StatefulWidget {
  const TopWidget({super.key});

  @override
  State<TopWidget> createState() => _TopWidgetState();
}

class _TopWidgetState extends State<TopWidget> {
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();
  int state = 0;

  void fetch() {
    final formattedStart = DateFormat('yyyy-MM-dd').format(startDate);
    final formattedEnd = DateFormat('yyyy-MM-dd').format(endDate);

    Provider.of<SinmungoProvider>(context, listen: false).fetchSinmungoList(
      fromDate: formattedStart,
      toDate: formattedEnd,
      state: state,
    );
  }

  Future<void> pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? startDate : endDate,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) startDate = picked;
        else endDate = picked;
      });
      fetch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () => pickDate(context, true),
              child: Text("Start: ${DateFormat('yyyy-MM-dd').format(startDate)}"),
            ),
            TextButton(
              onPressed: () => pickDate(context, false),
              child: Text("End: ${DateFormat('yyyy-MM-dd').format(endDate)}"),
            ),
          ],
        ),
        DropdownButton<int>(
          value: state,
          items: const [
            DropdownMenuItem(value: 0, child: Text("전체")),
            DropdownMenuItem(value: 1, child: Text("조치중")),
            DropdownMenuItem(value: 2, child: Text("조치완료")),
          ],
          onChanged: (val) {
            setState(() {
              state = val!;
              fetch();
            });
          },
        ),
      ],
    );
  }
}

