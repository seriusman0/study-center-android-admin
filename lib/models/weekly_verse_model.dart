class WeeklyVerseModel {
  final int id;
  final String date;
  final String verseReference; // e.g., "Yohanes 3:16"
  final String verseText;
  final String? note;

  WeeklyVerseModel({
    required this.id,
    required this.date,
    required this.verseReference,
    required this.verseText,
    this.note,
  });

  factory WeeklyVerseModel.fromJson(Map<String, dynamic> json) {
    return WeeklyVerseModel(
      id: json['id'] as int,
      date: json['tanggal'] ?? '',
      verseReference: json['referensi'] ?? '',
      verseText: json['teks'] ?? '',
      note: json['catatan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal': date,
      'referensi': verseReference,
      'teks': verseText,
      'catatan': note,
    };
  }
}
