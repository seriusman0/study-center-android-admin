import 'user_model.dart';
import 'cabang_model.dart';

class TagModel {
  final int id;
  final String name;
  final String slug;

  TagModel({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
    );
  }
}

class BlogModel {
  final int id;
  final int userId;
  final int cabangId;
  final String title;
  final String slug;
  final String content;
  final String? imagePath;
  final DateTime? publishedAt;
  final UserModel? user;
  final CabangModel? cabang;
  final List<TagModel> tags;

  BlogModel({
    required this.id,
    required this.userId,
    required this.cabangId,
    required this.title,
    required this.slug,
    required this.content,
    this.imagePath,
    this.publishedAt,
    this.user,
    this.cabang,
    required this.tags,
  });

  String? get imageUrl {
    if (imagePath == null) return null;
    if (imagePath!.startsWith('http')) return imagePath;
    // Serve from Laravel public storage route
    return 'https://studycenter.overcomer.my.id/storage/$imagePath';
  }

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    var tagList = json['tags'] as List? ?? [];
    List<TagModel> parsedTags = tagList.map((t) => TagModel.fromJson(t as Map<String, dynamic>)).toList();

    return BlogModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      cabangId: json['cabang_id'] as int,
      title: json['title'] as String,
      slug: json['slug'] as String,
      content: json['content'] as String,
      imagePath: json['image'] as String?,
      publishedAt: json['published_at'] != null ? DateTime.tryParse(json['published_at'] as String) : null,
      user: json['user'] != null ? UserModel.fromJson(json['user'] as Map<String, dynamic>) : null,
      cabang: json['cabang'] != null ? CabangModel.fromJson(json['cabang'] as Map<String, dynamic>) : null,
      tags: parsedTags,
    );
  }
}
