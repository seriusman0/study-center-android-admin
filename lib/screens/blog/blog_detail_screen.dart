import 'package:flutter/material.dart';
import '../../models/blog_model.dart';
import '../../constants/app_colors.dart';
import 'package:intl/intl.dart';

class BlogDetailScreen extends StatelessWidget {
  final BlogModel blog;

  const BlogDetailScreen({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    final dateStr = blog.publishedAt != null
        ? DateFormat('dd MMMM yyyy HH:mm').format(blog.publishedAt!)
        : '-';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detail Blog', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cover Image
            if (blog.imageUrl != null)
              Container(
                height: 220,
                decoration: BoxDecoration(
                  border: const Border(bottom: BorderSide(color: AppColors.border)),
                  image: DecorationImage(
                    image: NetworkImage(blog.imageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                height: 120,
                color: AppColors.primary.withOpacity(0.05),
                child: const Icon(Icons.article_outlined, size: 48, color: AppColors.primary),
              ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Branch & Tags Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          blog.cabang?.nama ?? 'Semua Cabang',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Blog Title
                  Text(
                    blog.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Meta Info Divider
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.primary.withOpacity(0.2),
                        child: Text(
                          (blog.user?.name ?? 'A').substring(0, 1).toUpperCase(),
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            blog.user?.name ?? 'Anonim',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            dateStr,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 12),

                  // Body Content
                  Text(
                    blog.content,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textPrimary,
                      height: 1.6,
                    ),
                  ),

                  // Tags display
                  if (blog.tags.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Divider(color: AppColors.border),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: blog.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '#${tag.name}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
