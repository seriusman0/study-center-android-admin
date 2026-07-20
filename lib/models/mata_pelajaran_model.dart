class MataPelajaranModel {
  final int id;
  final String name;
  final bool isActive;

  MataPelajaranModel({
    required this.id,
    required this.name,
    required this.isActive,
  });

  factory MataPelajaranModel.fromJson(Map<String, dynamic> json) {
    return MataPelajaranModel(
      id: json['id'] as int,
      name: json['name'] ?? json['nama'] as String,
      isActive: json['is_active'] == 1 || json['is_active'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_active': isActive,
    };
  }
}
