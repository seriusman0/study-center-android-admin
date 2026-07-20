import 'package:flutter_test/flutter_test.dart';
import 'package:study_center_admin/models/role_model.dart';
import 'package:study_center_admin/models/cabang_model.dart';
import 'package:study_center_admin/models/user_model.dart';
import 'package:study_center_admin/models/blog_model.dart';
import 'package:study_center_admin/models/dashboard_stats.dart';

void main() {
  group('JSON Model Deserialization Tests', () {
    test('RoleModel.fromJson parses successfully', () {
      final json = {'id': 2, 'name': 'admin', 'description': 'Administrator'};
      final role = RoleModel.fromJson(json);

      expect(role.id, 2);
      expect(role.name, 'admin');
      expect(role.description, 'Administrator');
    });

    test('CabangModel.fromJson parses successfully', () {
      final json = {
        'id': 1,
        'nama': 'Nias Pusat',
        'alamat': 'Jl. Diponegoro',
        'kontak': '0812345',
        'slug': 'nias-pusat'
      };
      final cabang = CabangModel.fromJson(json);

      expect(cabang.id, 1);
      expect(cabang.nama, 'Nias Pusat');
      expect(cabang.slug, 'nias-pusat');
    });

    test('UserModel.fromJson parses successfully with nested roles and cabang', () {
      final json = {
        'id': 10,
        'name': 'Test Admin',
        'username': 'testadmin',
        'email': 'test@admin.com',
        'is_active': true,
        'cabang_id': 1,
        'roles': [
          {'id': 2, 'name': 'admin', 'description': 'Administrator'}
        ],
        'cabang': {
          'id': 1,
          'nama': 'Nias Pusat',
          'alamat': 'Jl. Diponegoro',
          'kontak': '0812345',
          'slug': 'nias-pusat'
        }
      };

      final user = UserModel.fromJson(json);

      expect(user.id, 10);
      expect(user.name, 'Test Admin');
      expect(user.isActive, true);
      expect(user.roles.length, 1);
      expect(user.roles[0].name, 'admin');
      expect(user.cabang?.nama, 'Nias Pusat');
    });

    test('BlogModel.fromJson parses successfully and formats image URL correctly', () {
      final json = {
        'id': 5,
        'user_id': 10,
        'cabang_id': 1,
        'title': 'Test Post Title',
        'slug': 'test-post-title',
        'content': 'This is content.',
        'image': 'blogs/image.jpg',
        'published_at': '2026-07-15T00:00:00.000000Z',
        'tags': [
          {'id': 1, 'name': 'Akademik', 'slug': 'akademik'}
        ]
      };

      final blog = BlogModel.fromJson(json);

      expect(blog.id, 5);
      expect(blog.title, 'Test Post Title');
      expect(blog.imagePath, 'blogs/image.jpg');
      expect(blog.imageUrl, 'http://100.67.79.94:8888/storage/blogs/image.jpg');
      expect(blog.tags.length, 1);
      expect(blog.tags[0].name, 'Akademik');
    });

    test('DashboardStats.fromJson parses successfully', () {
      final json = {
        'users_by_role': [
          {'role': 'admin', 'total': 2},
          {'role': 'student', 'total': 15}
        ],
        'blogs_by_cabang': [
          {'cabang': 'Nias Pusat', 'total': 3}
        ],
        'total_users': 17,
        'total_blogs': 3,
        'total_comments': 10
      };

      final stats = DashboardStats.fromJson(json);

      expect(stats.totalUsers, 17);
      expect(stats.totalBlogs, 3);
      expect(stats.totalComments, 10);
      expect(stats.usersByRole.length, 2);
      expect(stats.usersByRole[0].role, 'admin');
      expect(stats.usersByRole[0].total, 2);
    });
  });

  group('Client-Side Authorization Logic Tests', () {
    test('Role check identifies admin role correctly', () {
      final rolesListAdmin = [
        {'id': 2, 'name': 'admin'},
        {'id': 3, 'name': 'mentor'}
      ];
      final rolesListNonAdmin = [
        {'id': 3, 'name': 'mentor'},
        {'id': 4, 'name': 'student'}
      ];

      final bool hasAdminRole = rolesListAdmin.any((role) => role['name'] == 'admin');
      final bool hasNonAdminRole = rolesListNonAdmin.any((role) => role['name'] == 'admin');

      expect(hasAdminRole, true);
      expect(hasNonAdminRole, false);
    });
  });
}
