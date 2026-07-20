import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/mata_pelajaran_provider.dart';
import '../../constants/app_colors.dart';
import '../../models/mata_pelajaran_model.dart';
import '../main_drawer.dart';

class MataPelajaranScreen extends StatefulWidget {
  const MataPelajaranScreen({super.key});

  @override
  State<MataPelajaranScreen> createState() => _MataPelajaranScreenState();
}

class _MataPelajaranScreenState extends State<MataPelajaranScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MataPelajaranProvider>(context, listen: false).fetchMataPelajaran();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MataPelajaranProvider>();
    final mapels = provider.mapels;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mata Pelajaran', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
      ),
      drawer: const MainDrawer(),
      body: provider.isLoading && mapels.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: provider.fetchMataPelajaran,
              child: mapels.isEmpty
                  ? ListView(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Center(
                            child: Text('Tidak ada mata pelajaran', style: TextStyle(color: AppColors.textSecondary)),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: mapels.length,
                      itemBuilder: (context, index) {
                        final mapel = mapels[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: mapel.isActive ? AppColors.primary.withOpacity(0.1) : Colors.grey.shade200,
                              child: Icon(Icons.menu_book, color: mapel.isActive ? AppColors.primary : Colors.grey),
                            ),
                            title: Text(mapel.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(mapel.isActive ? 'Aktif' : 'Non-aktif',
                                style: TextStyle(color: mapel.isActive ? AppColors.success : Colors.red, fontSize: 12)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: AppColors.primary),
                                  onPressed: () => _showDialog(context, provider, mapel: mapel),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: AppColors.error),
                                  onPressed: () => _confirmDelete(context, provider, mapel.id),
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

  void _showDialog(BuildContext context, MataPelajaranProvider provider, {MataPelajaranModel? mapel}) {
    final nameController = TextEditingController(text: mapel?.name ?? '');
    bool isActive = mapel?.isActive ?? true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateBuilder) {
            return AlertDialog(
              title: Text(mapel == null ? 'Tambah Mata Pelajaran' : 'Edit Mata Pelajaran'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nama Mata Pelajaran'),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Aktif'),
                    value: isActive,
                    onChanged: (val) {
                      setStateBuilder(() {
                        isActive = val;
                      });
                    },
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final data = {
                      'nama': nameController.text,
                      'is_active': isActive,
                    };
                    bool success;
                    if (mapel == null) {
                      success = await provider.createMataPelajaran(data);
                    } else {
                      success = await provider.updateMataPelajaran(mapel.id, data);
                    }
                    if (mounted) {
                      if (success) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berhasil disimpan!')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(provider.error ?? 'Gagal menyimpan')));
                      }
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, MataPelajaranProvider provider, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Mata Pelajaran?'),
        content: const Text('Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            onPressed: () async {
              final success = await provider.deleteMataPelajaran(id);
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
