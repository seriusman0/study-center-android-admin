import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../constants/app_colors.dart';
import 'main_drawer.dart';
import 'login_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar Aplikasi', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin ingin keluar dari akun administrator?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Keluar', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await Provider.of<AuthProvider>(context, listen: false).logout();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('Profil Saya', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Avatar and name
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      (user?.name ?? 'A').substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    user?.name ?? 'Administrator',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@${user?.username ?? 'admin'}',
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
                    'Informasi Akun',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 16),

                  _buildInfoRow('Email', user?.email ?? 'Tidak ada email'),
                  const Divider(color: AppColors.border),
                  _buildInfoRow('Cabang', user?.cabang?.nama ?? 'Semua Cabang (Pusat)'),
                  const Divider(color: AppColors.border),

                  const SizedBox(height: 8),
                  const Text(
                    'Daftar Role Akses',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (user?.roles ?? []).map((role) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          role.name.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Logout Action Button
            ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.white,
              foregroundColor: AppColors.error,
              elevation: 0,
              side: const BorderSide(color: AppColors.error, width: 1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ).child(
              onPressed: () => _handleLogout(context),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_outlined, size: 20),
                  SizedBox(width: 8),
                  Text('Keluar Akun', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
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

// Helper extension to make styling custom button layouts cleaner in Flutter
extension ElevatedButtonExtension on ButtonStyle {
  Widget child({required VoidCallback onPressed, required Widget child}) {
    return ElevatedButton(
      style: this,
      onPressed: onPressed,
      child: child,
    );
  }
}
