class BibleScheduleModel {
  final int id;
  final String date;
  final String readingReference; // e.g., "Kejadian 1-3"
  final String? note;

  BibleScheduleModel({
    required this.id,
    required this.date,
    required this.readingReference,
    this.note,
  });

  factory BibleScheduleModel.fromJson(Map<String, dynamic> json) {
    return BibleScheduleModel(
      id: json['id'] as int,
      date: json['tanggal'] ?? '',
      readingReference: json['referensi'] ?? '',
      note: json['catatan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal': date,
      'referensi': readingReference,
      'catatan': note,
    };
  }
}
