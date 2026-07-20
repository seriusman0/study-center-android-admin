class RoleStat {
  final String role;
  final int total;

  RoleStat({required this.role, required this.total});

  factory RoleStat.fromJson(Map<String, dynamic> json) {
    return RoleStat(
      role: json['role'] as String,
      total: json['total'] as int,
    );
  }
}

class CabangStat {
  final String cabang;
  final int total;

  CabangStat({required this.cabang, required this.total});

  factory CabangStat.fromJson(Map<String, dynamic> json) {
    return CabangStat(
      cabang: json['cabang'] as String,
      total: json['total'] as int,
    );
  }
}

class DashboardStats {
  final List<RoleStat> usersByRole;
  final List<CabangStat> blogsByCabang;
  final int totalUsers;
  final int totalBlogs;
  final int totalComments;

  DashboardStats({
    required this.usersByRole,
    required this.blogsByCabang,
    required this.totalUsers,
    required this.totalBlogs,
    required this.totalComments,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    var roleList = json['users_by_role'] as List? ?? [];
    List<RoleStat> parsedRoles = roleList.map((r) => RoleStat.fromJson(r as Map<String, dynamic>)).toList();

    var cabangList = json['blogs_by_cabang'] as List? ?? [];
    List<CabangStat> parsedCabangs = cabangList.map((c) => CabangStat.fromJson(c as Map<String, dynamic>)).toList();

    return DashboardStats(
      usersByRole: parsedRoles,
      blogsByCabang: parsedCabangs,
      totalUsers: json['total_users'] as int? ?? 0,
      totalBlogs: json['total_blogs'] as int? ?? 0,
      totalComments: json['total_comments'] as int? ?? 0,
    );
  }
}
