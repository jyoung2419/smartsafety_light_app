import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/sinmungo_provider.dart';
import '../../../widgets/sinmungo/detail/detail_content_widget.dart';
import '../../../widgets/sinmungo/detail/take_action_widget.dart';
import '../../../widgets/header.dart';

class SinmungoDetailScreen extends StatefulWidget {
  final int idx;
  final Map<String, dynamic>? preloadedData; // 추가

  const SinmungoDetailScreen({
    super.key,
    required this.idx,
    this.preloadedData,
  });

  @override
  State<SinmungoDetailScreen> createState() => _SinmungoDetailScreenState();
}

class _SinmungoDetailScreenState extends State<SinmungoDetailScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    final provider = Provider.of<SinmungoProvider>(context, listen: false);

    if (widget.preloadedData != null) {
      provider.sinmungoDetail = widget.preloadedData;
      setState(() {});
    }
    await provider.fetchSinmungoDetail(widget.idx.toString());
    if (widget.preloadedData != null) {
      provider.sinmungoDetail = {
        ...provider.sinmungoDetail ?? {},
        ...widget.preloadedData!,
      };
    }

    await provider.fetchReportCodes();
    await provider.fetchActionCodes();

    setState(() => _isLoading = false);
  }


  @override
  Widget build(BuildContext context) {
    final sinmungoDetail = Provider
        .of<SinmungoProvider>(context)
        .sinmungoDetail;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: _isLoading || sinmungoDetail == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          const Header(title: '안전신문고 조회', backgroundColor: Color(0xFFF2F2F2)),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SinmungoDetailContentWidget(
                    sinmungo: sinmungoDetail,
                    imgList: List<Map<String, dynamic>>.from(
                        sinmungoDetail['imgList'] ?? []),
                  ),
                  SinmungoTakeActionWidget(sinmungo: sinmungoDetail),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}