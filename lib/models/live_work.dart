class LiveWork {
  final String wnum;
  final String wname;
  final String wstart;
  final String wend;
  final String wcontent;
  final String wuser;
  final String wtel;
  final String wplace;
  final String wstate;
  final String dangerState;

  LiveWork({
    required this.wnum,
    required this.wname,
    required this.wstart,
    required this.wend,
    required this.wcontent,
    required this.wuser,
    required this.wtel,
    required this.wplace,
    required this.wstate,
    required this.dangerState
  });

  factory LiveWork.fromJson(Map<String, dynamic> json) {
    return LiveWork(
      wnum: json['WNUM']?.toString() ?? '',
      wname: json['WNAME']?.toString() ?? '',
      wstart: json['WSTART']?.toString() ?? '',
      wend: json['WEND']?.toString() ?? '',
      wcontent: json['WCONTENT']?.toString() ?? '',
      wuser: json['WUSER']?.toString() ?? '',
      wtel: json['WTEL']?.toString() ?? '',
      wplace: json['WPLACE']?.toString() ?? '',
      wstate: json['WSTATE']?.toString() ?? '',
      dangerState: json['DANGER_STATE']?.toString() ?? '',

    );
  }
}
