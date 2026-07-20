class PresensiModel {
  final int id;
  final String date;
  final String startTime;
  final String endTime;
  final String kelas;
  final String mapel;
  final String cabang;
  final String? note;
  final String? photoUrl;

  PresensiModel({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.kelas,
    required this.mapel,
    required this.cabang,
    this.note,
    this.photoUrl,
  });

  factory PresensiModel.fromJson(Map<String, dynamic> json) {
    return PresensiModel(
      id: json['id'] as int,
      date: json['tanggal'] ?? '',
      startTime: json['jam_mulai'] ?? '',
      endTime: json['jam_selesai'] ?? '',
      kelas: json['kelas']?['nama'] ?? 'Unknown Kelas',
      mapel: json['mata_pelajaran'] ?? 'Unknown Mapel',
      cabang: json['cabang']?['nama'] ?? 'Unknown Cabang',
      note: json['catatan'],
      photoUrl: json['foto_kegiatan'],
    );
  }
}
