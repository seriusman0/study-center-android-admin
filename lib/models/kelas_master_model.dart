class KelasMasterModel {
  final int id;
  final String nama;
  final String? cabangNama;
  final int? cabangId;
  final String? deskripsi;
  final bool isActive;

  KelasMasterModel({
    required this.id,
    required this.nama,
    this.cabangNama,
    this.cabangId,
    this.deskripsi,
    required this.isActive,
  });

  factory KelasMasterModel.fromJson(Map<String, dynamic> json) {
    return KelasMasterModel(
      id: json['id'] as int,
      nama: json['nama'] as String,
      cabangNama: (json['cabang'] is Map) ? json['cabang']['nama'] : json['cabang'] as String?,
      cabangId: json['cabang_id'] as int?,
      deskripsi: json['keterangan'] ?? json['deskripsi'] as String?,
      isActive: json['is_active'] == 1 || json['is_active'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'cabang_id': cabangId,
      'deskripsi': deskripsi,
      'is_active': isActive,
    };
  }
}
