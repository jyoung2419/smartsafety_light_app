class SinmungoModel {
  final int idx;
  final String impoType;
  final String position;
  final String reportUser;
  final String reportDate;
  final String reportContent;
  final String reportDescr;
  final String regDate;
  final String repairUser;
  final String repairCause;
  final String repairMeasure;
  final String repairRelapse;
  final String repairDescr;
  final String fileDescr1;
  final String fileDescr2;
  final String fileDescr3;
  final String fileDescr4;
  final String repairDate;
  final String repairState;
  final String reportEtcContent;
  final String repairEtcContent;

  SinmungoModel({
    required this.idx,
    required this.impoType,
    required this.position,
    required this.reportUser,
    required this.reportDate,
    required this.reportContent,
    required this.reportDescr,
    required this.regDate,
    required this.repairUser,
    required this.repairCause,
    required this.repairMeasure,
    required this.repairRelapse,
    required this.repairDescr,
    required this.fileDescr1,
    required this.fileDescr2,
    required this.fileDescr3,
    required this.fileDescr4,
    required this.repairDate,
    required this.repairState,
    required this.reportEtcContent,
    required this.repairEtcContent,
  });

  factory SinmungoModel.fromJson(Map<String, dynamic> json) {
    return SinmungoModel(
      idx: json['IDX'] ?? 0,
      impoType: json['IMPO_TYPE']?.toString() ?? '',
      position: json['POSITION']?.toString() ?? '',
      reportUser: json['REPORT_USER']?.toString() ?? '',
      reportDate: json['REPORT_DATE']?.toString() ?? '',
      reportContent: json['REPORT_CONTENT']?.toString() ?? '',
      reportDescr: json['REPORT_DESCR']?.toString() ?? '',
      regDate: json['REGDATE']?.toString() ?? '',
      repairUser: json['REPAIR_USER']?.toString() ?? '',
      repairCause: json['REPAIR_CAUSE']?.toString() ?? '',
      repairMeasure: json['REPAIR_MEASURE']?.toString() ?? '',
      repairRelapse: json['REPAIR_RELAPSE']?.toString() ?? '',
      repairDescr: json['REPAIR_DESCR']?.toString() ?? '',
      fileDescr1: json['FILEDESCR1']?.toString() ?? '',
      fileDescr2: json['FILEDESCR2']?.toString() ?? '',
      fileDescr3: json['FILEDESCR3']?.toString() ?? '',
      fileDescr4: json['FILEDESCR4']?.toString() ?? '',
      repairDate: json['REPAIR_DATE']?.toString() ?? '',
      repairState: json['REPAIR_STATE']?.toString() ?? '',
      reportEtcContent: json['REPORT_ETC_CONTENT']?.toString() ?? '',
      repairEtcContent: json['REPAIR_ETC_CONTENT']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IDX': idx,
      'IMPO_TYPE': impoType,
      'POSITION': position,
      'REPORT_USER': reportUser,
      'REPORT_DATE': reportDate,
      'REPORT_CONTENT': reportContent,
      'REPORT_DESCR': reportDescr,
      'REGDATE': regDate,
      'REPAIR_USER': repairUser,
      'REPAIR_CAUSE': repairCause,
      'REPAIR_MEASURE': repairMeasure,
      'REPAIR_RELAPSE': repairRelapse,
      'REPAIR_DESCR': repairDescr,
      'FILEDESCR1': fileDescr1,
      'FILEDESCR2': fileDescr2,
      'FILEDESCR3': fileDescr3,
      'FILEDESCR4': fileDescr4,
      'REPAIR_DATE': repairDate,
      'REPAIR_STATE': repairState,
      'REPORT_ETC_CONTENT': reportEtcContent,
      'REPAIR_ETC_CONTENT': repairEtcContent,
    };
  }
}
