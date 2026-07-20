class StudentProfileModel {
  final int id;
  final int userId;
  final String? studentNumber;
  final String? birthDate;
  final String? gender;
  final String? studentPhone;
  final String? photo;
  final List<String>? mataPelajaran;
  final bool isPending;
  final String? status;
  final String? catatanAdmin;
  final String? schoolName;
  final String? gradeClass;
  final int? entryYear;

  StudentProfileModel({
    required this.id,
    required this.userId,
    this.studentNumber,
    this.birthDate,
    this.gender,
    this.studentPhone,
    this.photo,
    this.mataPelajaran,
    required this.isPending,
    this.status,
    this.catatanAdmin,
    this.schoolName,
    this.gradeClass,
    this.entryYear,
  });

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    List<String>? parsedMapel;
    if (json['mata_pelajaran'] != null) {
      if (json['mata_pelajaran'] is List) {
        parsedMapel = List<String>.from(json['mata_pelajaran']);
      } else if (json['mata_pelajaran'] is String) {
        parsedMapel = [json['mata_pelajaran']];
      }
    }

    return StudentProfileModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      studentNumber: json['student_number'] as String?,
      birthDate: json['birth_date'] as String?,
      gender: json['gender'] as String?,
      studentPhone: json['student_phone'] as String?,
      photo: json['photo'] as String?,
      mataPelajaran: parsedMapel,
      isPending: json['is_pending'] == 1 || json['is_pending'] == true,
      status: json['status'] as String?,
      catatanAdmin: json['catatan_admin'] as String?,
      schoolName: json['school_name'] as String?,
      gradeClass: json['grade_class']?.toString(),
      entryYear: json['entry_year'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'student_number': studentNumber,
      'birth_date': birthDate,
      'gender': gender,
      'student_phone': studentPhone,
      'photo': photo,
      'mata_pelajaran': mataPelajaran,
      'is_pending': isPending,
      'status': status,
      'catatan_admin': catatanAdmin,
      'school_name': schoolName,
      'grade_class': gradeClass,
      'entry_year': entryYear,
    };
  }
}
