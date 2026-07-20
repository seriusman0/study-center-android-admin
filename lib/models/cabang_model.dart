class CabangModel {
  final int id;
  final String nama;
  final String? alamat;
  final String? kontak;
  final String slug;

  CabangModel({
    required this.id,
    required this.nama,
    this.alamat,
    this.kontak,
    required this.slug,
  });

  factory CabangModel.fromJson(Map<String, dynamic> json) {
    return CabangModel(
      id: json['id'] as int,
      nama: json['nama'] as String,
      alamat: json['alamat'] as String?,
      kontak: json['kontak'] as String?,
      slug: json['slug'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'alamat': alamat,
      'kontak': kontak,
      'slug': slug,
    };
  }
}
