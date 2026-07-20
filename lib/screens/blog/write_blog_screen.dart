import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'dart:convert';
import '../../providers/blog_provider.dart';
import '../../constants/app_colors.dart';

class WriteBlogScreen extends StatefulWidget {
  const WriteBlogScreen({super.key});

  @override
  State<WriteBlogScreen> createState() => _WriteBlogScreenState();
}

class _WriteBlogScreenState extends State<WriteBlogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final quill.QuillController _quillController = quill.QuillController.basic();
  final _tagsController = TextEditingController();
  
  int? _selectedCabangId;
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BlogProvider>(context, listen: false).fetchCabangs();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quillController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal memilih gambar'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _clearImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> _saveBlog() async {
    if (!_formKey.currentState!.validate()) return;
    
    // Check quill content
    final quillContent = jsonEncode(_quillController.document.toDelta().toJson());
    if (_quillController.document.isEmpty()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Konten tidak boleh kosong'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_selectedCabangId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih cabang terlebih dahulu'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final blogProvider = Provider.of<BlogProvider>(context, listen: false);

    // Split tags by comma
    List<String> tags = _tagsController.text
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();

    final success = await blogProvider.createBlog(
      title: _titleController.text.trim(),
      content: quillContent, // Sending JSON string of Delta
      cabangId: _selectedCabangId!,
      tags: tags,
      image: _selectedImage,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Blog berhasil disimpan'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop(true);
    } else if (mounted) {
      final error = blogProvider.errorMessage ?? 'Gagal menyimpan blog';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final blogProvider = context.watch<BlogProvider>();
    final cabangs = blogProvider.cabangs;
    final isSaving = blogProvider.isSaving;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tulis Blog Baru', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          if (isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveBlog,
              child: const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Text(
                  'Publish',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Quill Toolbar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: quill.QuillSimpleToolbar(
              controller: _quillController,
              config: const quill.QuillSimpleToolbarConfig(),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.border),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title Field
                    TextFormField(
                      controller: _titleController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Judul Artikel',
                        hintStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      validator: (value) => value == null || value.trim().isEmpty ? 'Judul tidak boleh kosong' : null,
                    ),
                    const Divider(color: AppColors.border, thickness: 1),
                    const SizedBox(height: 10),

                    // Cabang Picker
                    DropdownButtonFormField<int>(
                      value: _selectedCabangId,
                      decoration: InputDecoration(
                        labelText: 'Pilih Cabang',
                        labelStyle: const TextStyle(color: AppColors.textSecondary),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary),
                        ),
                      ),
                      items: cabangs.map((c) {
                        return DropdownMenuItem<int>(
                          value: c.id,
                          child: Text(c.nama),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedCabangId = val;
                        });
                      },
                      validator: (value) => value == null ? 'Pilih cabang asal' : null,
                    ),
                    const SizedBox(height: 16),

                    // Image Picker Area
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          if (_selectedImage == null)
                            TextButton.icon(
                              onPressed: _pickImage,
                              icon: const Icon(Icons.add_photo_alternate_outlined, color: AppColors.primary),
                              label: const Text('Tambah Foto Sampul', style: TextStyle(color: AppColors.primary)),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                              ),
                            )
                          else
                            Column(
                              children: [
                                Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        File(_selectedImage!.path),
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: _clearImage,
                                      child: Container(
                                        margin: const EdgeInsets.all(8),
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.close, color: Colors.white, size: 18),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 8),
                                TextButton.icon(
                                  onPressed: _pickImage,
                                  icon: const Icon(Icons.sync, color: AppColors.primary, size: 18),
                                  label: const Text('Ganti Gambar', style: TextStyle(color: AppColors.primary, fontSize: 13)),
                                )
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tags input
                    TextFormField(
                      controller: _tagsController,
                      decoration: InputDecoration(
                        labelText: 'Tags (pisahkan dengan koma)',
                        hintText: 'akademik, jurnal, info',
                        labelStyle: const TextStyle(color: AppColors.textSecondary),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary),
                        ),
                      ),
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 20),

                    // Content Editor (Body)
                    Container(
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: quill.QuillEditor.basic(
                        controller: _quillController,
                        config: const quill.QuillEditorConfig(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
