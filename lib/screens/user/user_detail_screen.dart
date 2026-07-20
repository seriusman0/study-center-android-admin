import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../constants/app_colors.dart';
import 'edit_user_screen.dart';

class UserDetailScreen extends StatefulWidget {
  final UserModel user;

  const UserDetailScreen({super.key, required this.user});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late UserModel _currentUser;
  bool _isToggling = false;
  bool _isLoadingDetail = false;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshDetail());
  }

  Future<void> _refreshDetail() async {
    setState(() => _isLoadingDetail = true);
    final fresh = await Provider.of<UserProvider>(context, listen: false)
        .fetchUserDetail(_currentUser.id);
    if (fresh != null && mounted) {
      setState(() => _currentUser = fresh);
    }
    if (mounted) setState(() => _isLoadingDetail = false);
  }

  Future<void> _toggleActiveStatus() async {
    setState(() => _isToggling = true);

    final success = await Provider.of<UserProvider>(context, listen: false)
        .toggleUserActive(_currentUser.id);

    if (success && mounted) {
      final newIsActive = !_currentUser.isActive;
      setState(() => _currentUser = _currentUser.copyWith(isActive: newIsActive));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status user diubah menjadi ${newIsActive ? "Aktif" : "Non-aktif"}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    if (mounted) setState(() => _isToggling = false);
  }

  Future<void> _deleteUser() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus User', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Apakah Anda yakin ingin menghapus user "${_currentUser.name}"? Tindakan ini tidak dapat dibatalkan.'),
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
      final success = await Provider.of<UserProvider>(context, listen: false).deleteUser(_currentUser.id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User berhasil dihapus'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detail User', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => EditUserScreen(user: _currentUser),
                ),
              );
              if (result == true && mounted) {
                _refreshDetail();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: _deleteUser,
          ),
        ],
      ),
      body: _isLoadingDetail
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Header Card
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      _currentUser.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _currentUser.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@${_currentUser.username}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Profile info details
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Profil',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 16),

                  _buildDetailRow('Email', _currentUser.email ?? '-'),
                  const Divider(color: AppColors.border),
                  _buildDetailRow('Cabang', _currentUser.cabang?.nama ?? 'Semua Cabang (Pusat)'),
                  const Divider(color: AppColors.border),
                  
                  // Active Status Switch row
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Status Akun',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        _isToggling
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                              )
                            : Switch(
                                value: _currentUser.isActive,
                                onChanged: (_) => _toggleActiveStatus(),
                                activeColor: AppColors.primary,
                              ),
                      ],
                    ),
                  ),
                  const Divider(color: AppColors.border),

                  // Role representation
                  const SizedBox(height: 8),
                  const Text(
                    'Role Akses',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _currentUser.roles.map((role) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          role.name.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
