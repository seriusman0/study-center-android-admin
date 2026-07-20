import 'user_model.dart';
import 'certificate_template_model.dart';

class IssuedCertificateModel {
  final int id;
  final int studentId;
  final int templateId;
  final String nomorSertifikat;
  final String namaKursus;
  final String tanggalLulus;
  final int issuedBy;
  final String issuedAt;
  final String filePath;
  final UserModel? student;
  final CertificateTemplateModel? template;

  IssuedCertificateModel({
    required this.id,
    required this.studentId,
    required this.templateId,
    required this.nomorSertifikat,
    required this.namaKursus,
    required this.tanggalLulus,
    required this.issuedBy,
    required this.issuedAt,
    required this.filePath,
    this.student,
    this.template,
  });

  factory IssuedCertificateModel.fromJson(Map<String, dynamic> json) {
    return IssuedCertificateModel(
      id: json['id'] as int,
      studentId: json['student_id'] as int,
      templateId: json['template_id'] as int,
      nomorSertifikat: json['nomor_sertifikat'] as String,
      namaKursus: json['nama_kursus'] as String,
      tanggalLulus: json['tanggal_lulus'] as String,
      issuedBy: json['issued_by'] as int,
      issuedAt: json['issued_at'] as String,
      filePath: json['file_path'] as String,
      student: json['student'] != null ? UserModel.fromJson(json['student']) : null,
      template: json['template'] != null ? CertificateTemplateModel.fromJson(json['template']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'template_id': templateId,
      'nomor_sertifikat': nomorSertifikat,
      'nama_kursus': namaKursus,
      'tanggal_lulus': tanggalLulus,
      'issued_by': issuedBy,
      'issued_at': issuedAt,
      'file_path': filePath,
    };
  }
}
