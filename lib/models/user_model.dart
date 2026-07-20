import 'role_model.dart';
import 'cabang_model.dart';
import 'student_profile_model.dart';

class UserModel {
  final int id;
  final String name;
  final String username;
  final String? email;
  final bool isActive;
  final int? cabangId;
  final List<RoleModel> roles;
  final CabangModel? cabang;
  final StudentProfileModel? studentProfile;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    this.email,
    required this.isActive,
    this.cabangId,
    required this.roles,
    this.cabang,
    this.studentProfile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var roleList = json['roles'] as List? ?? [];
    List<RoleModel> parsedRoles = roleList.map((r) => RoleModel.fromJson(r as Map<String, dynamic>)).toList();

    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String?,
      isActive: (json['is_active'] == 1 || json['is_active'] == true),
      cabangId: json['cabang_id'] as int?,
      roles: parsedRoles,
      cabang: json['cabang'] != null ? CabangModel.fromJson(json['cabang'] as Map<String, dynamic>) : null,
      studentProfile: json['student_profile'] != null ? StudentProfileModel.fromJson(json['student_profile'] as Map<String, dynamic>) : null,
    );
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? username,
    String? email,
    bool? isActive,
    int? cabangId,
    List<RoleModel>? roles,
    CabangModel? cabang,
    StudentProfileModel? studentProfile,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      cabangId: cabangId ?? this.cabangId,
      roles: roles ?? this.roles,
      cabang: cabang ?? this.cabang,
      studentProfile: studentProfile ?? this.studentProfile,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'is_active': isActive,
      'cabang_id': cabangId,
      'roles': roles.map((r) => r.toJson()).toList(),
      'cabang': cabang?.toJson(),
      'student_profile': studentProfile?.toJson(),
    };
  }
}
