import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/mentor_presensi_provider.dart';
import '../../constants/app_colors.dart';
import '../main_drawer.dart';

class MentorPresensiListScreen extends StatefulWidget {
  const MentorPresensiListScreen({super.key});

  @override
  State<MentorPresensiListScreen> createState() => _MentorPresensiListScreenState();
}

class _MentorPresensiListScreenState extends State<MentorPresensiListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MentorPresensiProvider>(context, listen: false).fetchPresensi();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MentorPresensiProvider>();
    final list = provider.presensiList;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Presensi Mentor', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: provider.fetchPresensi,
          )
        ],
      ),
      drawer: const MainDrawer(),
      body: provider.isLoading && list.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : list.isEmpty
              ? const Center(
                  child: Text('Tidak ada data presensi mentor', style: TextStyle(color: AppColors.textSecondary)),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item.tanggal, style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text('${item.durasiMenit} m', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Mentor: ${item.mentorName ?? "-"}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text('Cabang: ${item.cabangNama ?? "-"} | Kelas: ${item.kelasNama ?? "-"}', style: const TextStyle(color: AppColors.textSecondary)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 16, color: Colors.green),
                                const SizedBox(width: 4),
                                Text(item.jamDatang),
                                const SizedBox(width: 16),
                                const Icon(Icons.access_time_filled, size: 16, color: Colors.red),
                                const SizedBox(width: 4),
                                Text(item.jamPulang),
                                const SizedBox(width: 16),
                                const Icon(Icons.people, size: 16, color: Colors.indigo),
                                const SizedBox(width: 4),
                                Text('${item.jumlahMurid} Siswa'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

