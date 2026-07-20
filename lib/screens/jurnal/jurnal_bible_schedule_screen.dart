import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bible_schedule_provider.dart';
import '../../constants/app_colors.dart';
import '../../models/bible_schedule_model.dart';
import '../main_drawer.dart';

class JurnalBibleScheduleScreen extends StatefulWidget {
  const JurnalBibleScheduleScreen({super.key});

  @override
  State<JurnalBibleScheduleScreen> createState() => _JurnalBibleScheduleScreenState();
}

class _JurnalBibleScheduleScreenState extends State<JurnalBibleScheduleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BibleScheduleProvider>(context, listen: false).fetchSchedules();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BibleScheduleProvider>();
    final schedules = provider.schedules;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bible Schedule', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
      ),
      drawer: const MainDrawer(),
      body: provider.isLoading && schedules.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: provider.fetchSchedules,
              child: schedules.isEmpty
                  ? ListView(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Center(
                            child: Text('Tidak ada jadwal', style: TextStyle(color: AppColors.textSecondary)),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: schedules.length,
                      itemBuilder: (context, index) {
                        final schedule = schedules[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.teal,
                              child: Icon(Icons.book, color: Colors.white),
                            ),
                            title: Text(schedule.readingReference, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(schedule.date),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: AppColors.primary),
                                  onPressed: () => _showDialog(context, provider, schedule: schedule),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: AppColors.error),
                                  onPressed: () => _confirmDelete(context, provider, schedule.id),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(context, provider),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showDialog(BuildContext context, BibleScheduleProvider provider, {BibleScheduleModel? schedule}) {
    final refController = TextEditingController(text: schedule?.readingReference ?? '');
    final dateController = TextEditingController(text: schedule?.date ?? '');
    final noteController = TextEditingController(text: schedule?.note ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(schedule == null ? 'Tambah Jadwal' : 'Edit Jadwal'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: 'Tanggal (YYYY-MM-DD)', hintText: 'Contoh: 2026-07-17'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: refController,
                  decoration: const InputDecoration(labelText: 'Referensi', hintText: 'Contoh: Kejadian 1-3'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(labelText: 'Catatan'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final data = {
                  'tanggal': dateController.text,
                  'referensi': refController.text,
                  'catatan': noteController.text,
                };
                bool success;
                if (schedule == null) {
                  success = await provider.createSchedule(data);
                } else {
                  success = await provider.updateSchedule(schedule.id, data);
                }
                if (mounted && success) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, BibleScheduleProvider provider, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Jadwal?'),
        content: const Text('Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            onPressed: () async {
              final success = await provider.deleteSchedule(id);
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
