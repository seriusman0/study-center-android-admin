import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../constants/app_colors.dart';
import 'blog/write_blog_screen.dart';
import 'main_drawer.dart';
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

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    await Provider.of<UserProvider>(context, listen: false).fetchDashboardStats();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userProvider = context.watch<UserProvider>();
    final stats = userProvider.stats;

    final userName = authProvider.user?.name ?? 'Admin';

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: _loadData,
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Card
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: AppColors.primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1F0E8E6D),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang,',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Koneksi: Active (studycenter.overcomer.my.id)',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Statistics Section Header
              const Text(
                'Ikhtisar Data',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),

              // Dynamic Stats Cards
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      'Total User',
                      stats?.totalUsers.toString() ?? '-',
                      Icons.people_outline,
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildMetricCard(
                      'Total Blog',
                      stats?.totalBlogs.toString() ?? '-',
                      Icons.article_outlined,
                      AppColors.accent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      'Total Komentar',
                      stats?.totalComments.toString() ?? '-',
                      Icons.comment_outlined,
                      AppColors.primaryLight,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildMetricCard(
                      'Total Cabang',
                      '12', // Placeholder
                      Icons.apartment_outlined,
                      AppColors.success,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),
              
              // Chart Placeholder
              const Text(
                'Grafik Blog per Cabang',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                height: 200,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Center(
                  child: Text('Bar Chart Placeholder (fl_chart)', style: TextStyle(color: AppColors.textSecondary)),
                ),
              ),

              const SizedBox(height: 28),

              // Role Distribution Card
              const Text(
                'Distribusi Role User',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),

              userProvider.isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: CircularProgressIndicator(color: AppColors.primary),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: stats != null && stats.usersByRole.isNotEmpty
                          ? Column(
                              children: stats.usersByRole.map((roleStat) {
                                // Calculate simple bar width based on max users
                                final total = stats.totalUsers > 0 ? stats.totalUsers : 1;
                                final double percentage = roleStat.total / total;
                                final String roleLabel =
                                    roleStat.role.toUpperCase();

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 14.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            roleLabel,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          Text(
                                            '${roleStat.total} User',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: LinearProgressIndicator(
                                          value: percentage,
                                          backgroundColor: AppColors.background,
                                          color: AppColors.primary,
                                          minHeight: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            )
                          : const Center(
                              child: Text(
                                'Data Distribusi Kosong',
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                            ),
                    ),

              const SizedBox(height: 28),

              // All Features Grid
              const Text(
                'Semua Fitur',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9,
                children: [
                  _buildGridFeature(context, 'Tulis Blog', Icons.edit_note_outlined, AppColors.primary, const WriteBlogScreen()),
                  _buildGridFeature(context, 'Cabang', Icons.apartment, AppColors.success, const CabangScreen()),
                  _buildGridFeature(context, 'Mapel', Icons.menu_book, AppColors.accent, const MataPelajaranScreen()),
                  _buildGridFeature(context, 'Kelas', Icons.class_, AppColors.primaryLight, const KelasMasterScreen()),
                  _buildGridFeature(context, 'Presensi', Icons.check_circle_outline, AppColors.warning, const PresensiListScreen()),
                  _buildGridFeature(context, 'Jurnal', Icons.assignment, Colors.indigo, const JurnalLifeItemsScreen()),
                  _buildGridFeature(context, 'Mentor', Icons.person_pin, Colors.teal, const MentorPresensiListScreen()),
                  _buildGridFeature(context, 'Daftar', Icons.how_to_reg, Colors.blue, const PendaftaranListScreen()),
                  _buildGridFeature(context, 'Sertifikat', Icons.workspace_premium, Colors.amber, const CertificateTemplateScreen()),
                  _buildGridFeature(context, 'Name Tag', Icons.badge, Colors.deepOrange, const NametagScreen()),
                  _buildGridFeature(context, 'Roles', Icons.admin_panel_settings, Colors.red, const RolesScreen()),
                  _buildGridFeature(context, 'College', Icons.school, Colors.purple, const CollegeJurnalAdminScreen()),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridFeature(BuildContext context, String label, IconData icon, Color color, Widget screen) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    bool isFullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: color,
              size: 26,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
