class CollegeBibleModel {
  final int dayNo;
  final String plText;
  final String pbText;

  CollegeBibleModel({
    required this.dayNo,
    required this.plText,
    required this.pbText,
  });

  factory CollegeBibleModel.fromJson(Map<String, dynamic> json) {
    return CollegeBibleModel(
      dayNo: json['day_no'] as int? ?? 0,
      plText: json['pl_text'] as String? ?? '',
      pbText: json['pb_text'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day_no': dayNo,
      'pl_text': plText,
      'pb_text': pbText,
    };
  }
}
