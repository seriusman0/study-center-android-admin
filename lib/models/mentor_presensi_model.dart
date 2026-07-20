class MentorPresensiModel {
  final int id;
  final String tanggal;
  final String jamDatang;
  final String jamPulang;
  final int durasiMenit;
  final int jumlahMurid;
  final String? mentorName;
  final String? cabangNama;
  final String? kelasNama;

  MentorPresensiModel({
    required this.id,
    required this.tanggal,
    required this.jamDatang,
    required this.jamPulang,
    required this.durasiMenit,
    required this.jumlahMurid,
    this.mentorName,
    this.cabangNama,
    this.kelasNama,
  });

  factory MentorPresensiModel.fromJson(Map<String, dynamic> json) {
    return MentorPresensiModel(
      id: json['id'] as int,
      tanggal: json['tanggal'] ?? '',
      jamDatang: json['jam_datang'] ?? '',
      jamPulang: json['jam_pulang'] ?? '',
      durasiMenit: json['durasi_menit'] ?? 0,
      jumlahMurid: json['jumlah_murid'] ?? 0,
      mentorName: json['mentor']?['name'],
      cabangNama: json['cabang']?['nama'],
      kelasNama: json['kelas']?['nama'],
    );
  }
}
