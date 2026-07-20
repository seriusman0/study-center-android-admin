class CollegeItemModel {
  final int id;
  final String kategori;
  final String label;
  final String responseType;
  final bool isDefault;
  final bool isActive;

  CollegeItemModel({
    required this.id,
    required this.kategori,
    required this.label,
    required this.responseType,
    required this.isDefault,
    required this.isActive,
  });

  factory CollegeItemModel.fromJson(Map<String, dynamic> json) {
    return CollegeItemModel(
      id: json['id'] as int,
      kategori: json['kategori'] ?? '',
      label: json['label'] ?? '',
      responseType: json['response_type'] ?? '',
      isDefault: json['is_default'] == 1 || json['is_default'] == true,
      isActive: json['is_active'] == 1 || json['is_active'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kategori': kategori,
      'label': label,
      'response_type': responseType,
      'is_default': isDefault,
      'is_active': isActive,
    };
  }
}
