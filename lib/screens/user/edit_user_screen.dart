import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../providers/blog_provider.dart';
import '../../constants/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditUserScreen extends StatefulWidget {
  final UserModel? user;

  const EditUserScreen({super.key, this.user});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  int? _selectedCabangId;
  bool _isActive = true;
  XFile? _selectedAvatar;
  final ImagePicker _picker = ImagePicker();

  // Selected roles map
  final Map<String, bool> _rolesMap = {
    'admin': false,
    'mentor': false,
    'student': false,
    'fulltimer': false,
    'college': false,
    'guest': false,
  };

  bool get isEditMode => widget.user != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BlogProvider>(context, listen: false).fetchCabangs();
    });

    if (isEditMode) {
      final u = widget.user!;
      _nameController.text = u.name;
      _usernameController.text = u.username;
      _emailController.text = u.email ?? '';
      _selectedCabangId = u.cabangId;
      _isActive = u.isActive;

      // Populate roles
      for (final r in u.roles) {
        if (_rolesMap.containsKey(r.name)) {
          _rolesMap[r.name] = true;
        }
      }
    } else {
      // Default for new user
      _rolesMap['student'] = true;
    }
  }

  Future<void> _pickAvatar() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedAvatar = image;
        });
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memilih avatar'), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Extract selected roles
    List<String> selectedRoles = [];
    _rolesMap.forEach((role, isChecked) {
      if (isChecked) selectedRoles.add(role);
    });

    if (selectedRoles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih setidaknya satu role untuk user'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    bool success;
    if (isEditMode) {
      success = await userProvider.updateUser(
        widget.user!.id,
        name: _nameController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        password: _passwordController.text.isEmpty ? null : _passwordController.text,
        cabangId: _selectedCabangId,
        isActive: _isActive,
        roleNames: selectedRoles,
      );
    } else {
      success = await userProvider.createUser(
        name: _nameController.text.trim(),
        email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        password: _passwordController.text.isEmpty ? '12345' : _passwordController.text,
        cabangId: _selectedCabangId,
        roleNames: selectedRoles,
      );
    }

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEditMode ? 'User berhasil diperbarui' : 'User berhasil dibuat'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop(true);
    } else if (mounted) {
      final error = userProvider.errorMessage ?? 'Gagal menyimpan data user';
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
    final userProvider = context.watch<UserProvider>();
    final blogProvider = context.watch<BlogProvider>();
    final isSaving = userProvider.isSaving;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit User' : 'Tambah User', style: const TextStyle(fontWeight: FontWeight.bold)),
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
              onPressed: _save,
              child: const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Text(
                  'Simpan',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Basic Information Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Informasi Dasar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 16),

                    // Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Lengkap',
                        prefixIcon: Icon(Icons.person_outline, size: 20),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.trim().isEmpty ? 'Nama tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 16),

                    // Username (Edit mode only)
                    if (isEditMode) ...[
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.alternate_email, size: 20),
                          border: OutlineInputBorder(),
                          helperText: 'Hanya huruf kecil dan angka saja',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Username tidak boleh kosong';
                          if (!RegExp(r'^[a-z0-9]+$').hasMatch(value)) {
                            return 'Hanya boleh berisi huruf kecil dan angka';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email (Opsional)',
                        prefixIcon: Icon(Icons.email_outlined, size: 20),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // Password / Reset Password
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: isEditMode ? 'Ganti Password (Kosongkan jika tidak diubah)' : 'Password (Default: 12345)',
                        prefixIcon: const Icon(Icons.lock_outline, size: 20),
                        border: const OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (!isEditMode && value != null && value.isNotEmpty && value.length < 5) {
                          return 'Password minimal 5 karakter';
                        }
                        if (isEditMode && value != null && value.isNotEmpty && value.length < 5) {
                          return 'Password baru minimal 5 karakter';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Cabang affiliation
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.all(16),
                child: DropdownButtonFormField<int?>(
                  value: _selectedCabangId,
                  decoration: const InputDecoration(
                    labelText: 'Cabang Akademik',
                    prefixIcon: Icon(Icons.apartment_outlined, size: 20),
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem<int?>(value: null, child: Text('Semua Cabang (Pusat)')),
                    ...blogProvider.cabangs.map((c) {
                      return DropdownMenuItem<int?>(value: c.id, child: Text(c.nama));
                    })
                  ],
                  onChanged: (val) {
                    setState(() {
                      _selectedCabangId = val;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Roles settings
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pilih Role Akses', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 12),
                    ..._rolesMap.keys.map((role) {
                      return CheckboxListTile(
                        title: Text(role.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        value: _rolesMap[role],
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() {
                            _rolesMap[role] = val ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      );
                    }),
                  ],
                ),
              ),
              
              if (isEditMode) ...[
                const SizedBox(height: 20),
                // Status Account Toggle
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SwitchListTile(
                    title: const Text('Akun Aktif', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    value: _isActive,
                    onChanged: (val) {
                      setState(() {
                        _isActive = val;
                      });
                    },
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
