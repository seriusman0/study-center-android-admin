import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/presensi_provider.dart';
import '../../constants/app_colors.dart';
import '../main_drawer.dart';
import 'presensi_create_screen.dart';
import 'presensi_detail_screen.dart';

class PresensiListScreen extends StatefulWidget {
  const PresensiListScreen({super.key});

  @override
  State<PresensiListScreen> createState() => _PresensiListScreenState();
}

class _PresensiListScreenState extends State<PresensiListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PresensiProvider>(context, listen: false).fetchPresensi();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PresensiProvider>();
    final list = provider.presensiList;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Data Presensi', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
      ),
      drawer: const MainDrawer(),
      body: provider.isLoading && list.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: provider.fetchPresensi,
              child: list.isEmpty
                  ? ListView(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Center(
                            child: Text('Tidak ada data presensi', style: TextStyle(color: AppColors.textSecondary)),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: AppColors.primary,
                              child: Icon(Icons.check_circle_outline, color: Colors.white),
                            ),
                            title: Text('${item.mapel} - ${item.kelas}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('${item.date} | ${item.startTime} - ${item.endTime}\n${item.cabang}'),
                            isThreeLine: true,
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: AppColors.error),
                              onPressed: () => _confirmDelete(context, provider, item.id),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PresensiDetailScreen(presensi: item),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PresensiCreateScreen()),
          ).then((_) {
            provider.fetchPresensi();
          });
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _confirmDelete(BuildContext context, PresensiProvider provider, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Presensi?'),
        content: const Text('Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            onPressed: () async {
              final success = await provider.deletePresensi(id);
              if (mounted && success) {
                Navigator.pop(context);
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
