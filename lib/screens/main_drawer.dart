import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../constants/app_colors.dart';
import 'cabang/cabang_screen.dart';
import 'mata_pelajaran/mata_pelajaran_screen.dart';
import 'kelas_master/kelas_master_screen.dart';
import 'presensi/presensi_list_screen.dart';
import 'jurnal/jurnal_life_items_screen.dart';
import 'mentor_presensi/mentor_presensi_list_screen.dart';
import 'pendaftaran/pendaftaran_list_screen.dart';
import 'certificate/certificate_template_screen.dart';
import 'nametag/nametag_screen.dart';
import 'roles_permissions/roles_screen.dart';
import 'college_jurnal/college_jurnal_admin_screen.dart';
import '../main.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.primary,
            ),
            child: Text(
              'Study Center Admin',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildDrawerItem(context, Icons.class_, 'Kelas Master', const KelasMasterScreen()),
          _buildDrawerItem(context, Icons.apartment, 'Cabang', const CabangScreen()),
          _buildDrawerItem(context, Icons.menu_book, 'Mata Pelajaran', const MataPelajaranScreen()),
          _buildDrawerItem(context, Icons.check_circle_outline, 'Presensi Siswa', const PresensiListScreen()),
          _buildDrawerItem(context, Icons.assignment, 'Jurnal', const JurnalLifeItemsScreen()),
          _buildDrawerItem(context, Icons.person_pin, 'Mentor Presensi', const MentorPresensiListScreen()),
          _buildDrawerItem(context, Icons.how_to_reg, 'Pendaftaran', const PendaftaranListScreen()),
          _buildDrawerItem(context, Icons.workspace_premium, 'Sertifikat', const CertificateTemplateScreen()),
          _buildDrawerItem(context, Icons.badge, 'Name Tags', const NametagScreen()),
          _buildDrawerItem(context, Icons.admin_panel_settings, 'Roles & Permissions', const RolesScreen()),
          _buildDrawerItem(context, Icons.school, 'College Jurnal', const CollegeJurnalAdminScreen()),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text('Keluar', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.error)),
            onTap: () async {
              await Provider.of<AuthProvider>(context, listen: false).logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const AuthWrapper()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, Widget screen) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
    );
  }
}
