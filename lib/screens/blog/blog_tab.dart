import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/blog_provider.dart';
import '../../constants/app_colors.dart';
import '../../models/blog_model.dart';
import 'blog_detail_screen.dart';
import '../main_drawer.dart';
import 'write_blog_screen.dart';
import 'package:intl/intl.dart';

class BlogTab extends StatefulWidget {
  const BlogTab({super.key});

  @override
  State<BlogTab> createState() => _BlogTabState();
}

class _BlogTabState extends State<BlogTab> {
  final _searchController = TextEditingController();
  String? _selectedCabangSlug;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final blogProvider = Provider.of<BlogProvider>(context, listen: false);
    await blogProvider.fetchCabangs();
    await blogProvider.fetchBlogs(
      search: _searchController.text,
      cabangSlug: _selectedCabangSlug,
    );
  }

  void _onSearchChanged() {
    Provider.of<BlogProvider>(context, listen: false).fetchBlogs(
      search: _searchController.text,
      cabangSlug: _selectedCabangSlug,
    );
  }

  void _selectCabang(String? slug) {
    setState(() {
      _selectedCabangSlug = slug;
    });
    Provider.of<BlogProvider>(context, listen: false).fetchBlogs(
      search: _searchController.text,
      cabangSlug: _selectedCabangSlug,
    );
  }

  Future<void> _confirmDelete(BlogModel blog) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Blog', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Apakah Anda yakin ingin menghapus blog "${blog.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Hapus', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final success = await Provider.of<BlogProvider>(context, listen: false).deleteBlog(blog.id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Blog berhasil dihapus'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final blogProvider = context.watch<BlogProvider>();
    final blogs = blogProvider.blogs;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('Daftar Blog', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const WriteBlogScreen()),
          );
          if (result == true) {
            _loadData();
          }
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.edit),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _onSearchChanged(),
              decoration: InputDecoration(
                hintText: 'Cari judul blog...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ),

          // Horizontal Branch Filters
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: const Text('Semua Cabang'),
                    selected: _selectedCabangSlug == null,
                    onSelected: (_) => _selectCabang(null),
                    backgroundColor: Colors.white,
                    selectedColor: AppColors.primary.withOpacity(0.15),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: _selectedCabangSlug == null ? FontWeight.bold : FontWeight.normal,
                      color: _selectedCabangSlug == null ? AppColors.primary : AppColors.textPrimary,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                ...blogProvider.cabangs.map((c) {
                  final isSelected = _selectedCabangSlug == c.slug;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(c.nama),
                      selected: isSelected,
                      onSelected: (_) => _selectCabang(c.slug),
                      backgroundColor: Colors.white,
                      selectedColor: AppColors.primary.withOpacity(0.15),
                      checkmarkColor: AppColors.primary,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Blog List
          Expanded(
            child: blogProvider.isLoading && blogs.isEmpty
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : RefreshIndicator(
                    onRefresh: _loadData,
                    color: AppColors.primary,
                    child: blogs.isEmpty
                        ? ListView(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(40.0),
                                child: Center(
                                  child: Text(
                                    'Tidak ada artikel blog ditemukan',
                                    style: TextStyle(color: AppColors.textSecondary),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: blogs.length,
                            itemBuilder: (context, index) {
                              final blog = blogs[index];
                              final dateStr = blog.publishedAt != null
                                  ? DateFormat('dd MMM yyyy').format(blog.publishedAt!)
                                  : '-';

                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => BlogDetailScreen(blog: blog),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Blog thumbnail if exists
                                        if (blog.imageUrl != null)
                                          Container(
                                            width: 80,
                                            height: 80,
                                            margin: const EdgeInsets.only(right: 14),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(14),
                                              border: Border.all(color: AppColors.border),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.network(
                                                blog.imageUrl!,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) => Container(
                                                  color: AppColors.background,
                                                  child: const Icon(Icons.image, color: AppColors.textSecondary),
                                                ),
                                              ),
                                            ),
                                          ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Branch Badge
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary.withOpacity(0.08),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  blog.cabang?.nama ?? 'Semua Cabang',
                                                  style: const TextStyle(
                                                    color: AppColors.primary,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              // Title
                                              Text(
                                                blog.title,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              // Metadata (Author & Date)
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    'Oleh: ${blog.user?.name ?? 'Anonim'}',
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      color: AppColors.textSecondary,
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
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                                          onPressed: () => _confirmDelete(blog),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}
