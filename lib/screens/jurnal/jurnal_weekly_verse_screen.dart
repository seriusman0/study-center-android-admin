import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/weekly_verse_provider.dart';
import '../../constants/app_colors.dart';
import '../../models/weekly_verse_model.dart';
import '../main_drawer.dart';

class JurnalWeeklyVerseScreen extends StatefulWidget {
  const JurnalWeeklyVerseScreen({super.key});

  @override
  State<JurnalWeeklyVerseScreen> createState() => _JurnalWeeklyVerseScreenState();
}

class _JurnalWeeklyVerseScreenState extends State<JurnalWeeklyVerseScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeeklyVerseProvider>(context, listen: false).fetchVerses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeeklyVerseProvider>();
    final verses = provider.verses;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Weekly Verse', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
      ),
      drawer: const MainDrawer(),
      body: provider.isLoading && verses.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: provider.fetchVerses,
              child: verses.isEmpty
                  ? ListView(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Center(
                            child: Text('Tidak ada mingguan ayat', style: TextStyle(color: AppColors.textSecondary)),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: verses.length,
                      itemBuilder: (context, index) {
                        final verse = verses[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.indigo,
                              child: Icon(Icons.menu_book, color: Colors.white),
                            ),
                            title: Text(verse.verseReference, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('${verse.date}\n${verse.verseText}'),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: AppColors.primary),
                                  onPressed: () => _showDialog(context, provider, verse: verse),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: AppColors.error),
                                  onPressed: () => _confirmDelete(context, provider, verse.id),
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

  void _showDialog(BuildContext context, WeeklyVerseProvider provider, {WeeklyVerseModel? verse}) {
    final refController = TextEditingController(text: verse?.verseReference ?? '');
    final dateController = TextEditingController(text: verse?.date ?? '');
    final textController = TextEditingController(text: verse?.verseText ?? '');
    final noteController = TextEditingController(text: verse?.note ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(verse == null ? 'Tambah Ayat' : 'Edit Ayat'),
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
                  decoration: const InputDecoration(labelText: 'Referensi', hintText: 'Contoh: Yohanes 3:16'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: textController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Isi Teks Ayat'),
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
                  'teks': textController.text,
                  'catatan': noteController.text,
                };
                bool success;
                if (verse == null) {
                  success = await provider.createVerse(data);
                } else {
                  success = await provider.updateVerse(verse.id, data);
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

  void _confirmDelete(BuildContext context, WeeklyVerseProvider provider, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Ayat?'),
        content: const Text('Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            onPressed: () async {
              final success = await provider.deleteVerse(id);
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
