class RoleModel {
  final int id;
  final String name;
  final String? description;

  RoleModel({
    required this.id,
    required this.name,
    this.description,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
