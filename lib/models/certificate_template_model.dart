class CertificateTemplateModel {
  final int id;
  final String nama;
  final String? deskripsi;
  final String htmlContent;
  final String orientation;
  final String paperSize;
  final bool isActive;
  final String? logoPath;
  final int createdBy;

  CertificateTemplateModel({
    required this.id,
    required this.nama,
    this.deskripsi,
    required this.htmlContent,
    required this.orientation,
    required this.paperSize,
    required this.isActive,
    this.logoPath,
    required this.createdBy,
  });

  factory CertificateTemplateModel.fromJson(Map<String, dynamic> json) {
    return CertificateTemplateModel(
      id: json['id'] as int,
      nama: json['nama'] as String,
      deskripsi: json['deskripsi'] as String?,
      htmlContent: json['html_content'] as String,
      orientation: json['orientation'] as String? ?? 'landscape',
      paperSize: json['paper_size'] as String? ?? 'a4',
      isActive: json['is_active'] == 1 || json['is_active'] == true,
      logoPath: json['logo_path'] as String?,
      createdBy: json['created_by'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'deskripsi': deskripsi,
      'html_content': htmlContent,
      'orientation': orientation,
      'paper_size': paperSize,
      'is_active': isActive,
      'logo_path': logoPath,
      'created_by': createdBy,
    };
  }
}
