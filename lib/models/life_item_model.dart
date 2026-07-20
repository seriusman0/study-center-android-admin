class LifeItemModel {
  final int id;
  final String kategori;
  final String label;
  final bool isDefault;
  final bool isActive;

  LifeItemModel({
    required this.id,
    required this.kategori,
    required this.label,
    required this.isDefault,
    required this.isActive,
  });

  factory LifeItemModel.fromJson(Map<String, dynamic> json) {
    return LifeItemModel(
      id: json['id'] as int,
      kategori: json['kategori'] ?? '',
      label: json['label'] ?? '',
      isDefault: json['is_default'] == 1 || json['is_default'] == true,
      isActive: json['is_active'] == 1 || json['is_active'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kategori': kategori,
      'label': label,
      'is_default': isDefault,
      'is_active': isActive,
    };
  }
}
