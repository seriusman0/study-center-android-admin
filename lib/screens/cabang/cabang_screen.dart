import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cabang_provider.dart';
import '../../models/cabang_model.dart';
import '../../constants/app_colors.dart';
import '../main_drawer.dart';

class CabangScreen extends StatefulWidget {
  const CabangScreen({super.key});

  @override
  State<CabangScreen> createState() => _CabangScreenState();
}

class _CabangScreenState extends State<CabangScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CabangProvider>(context, listen: false).fetchCabangs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cabangProvider = context.watch<CabangProvider>();
    final cabangs = cabangProvider.cabangs;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Manajemen Cabang', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
      ),
      drawer: const MainDrawer(),
      body: cabangProvider.isLoading && cabangs.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: cabangProvider.fetchCabangs,
              child: cabangs.isEmpty
                  ? ListView(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Center(
                            child: Text(
                              'Tidak ada cabang',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 88),
                      itemCount: cabangs.length,
                      itemBuilder: (context, index) {
                        final cabang = cabangs[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            onTap: () => _showCabangDialog(context, cabangProvider, cabang: cabang),
                            leading: const CircleAvatar(
                              backgroundColor: AppColors.primary,
                              child: Icon(Icons.apartment, color: Colors.white),
                            ),
                            title: Text(cabang.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(cabang.alamat ?? 'Tidak ada alamat'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Semantics(
                                  identifier: 'edit_${cabang.nama}',
                                  child: IconButton(
                                    icon: const Icon(Icons.edit, color: AppColors.primary),
                                    onPressed: () => _showCabangDialog(context, cabangProvider, cabang: cabang),
                                    tooltip: 'Edit Cabang',
                                  ),
                                ),
                                Semantics(
                                  identifier: 'delete_${cabang.nama}',
                                  child: IconButton(
                                    icon: const Icon(Icons.delete, color: AppColors.error),
                                    onPressed: () => _confirmDelete(context, cabangProvider, cabang.id),
                                    tooltip: 'Hapus Cabang',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Tambah Cabang',
        onPressed: () => _showCabangDialog(context, cabangProvider),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showCabangDialog(BuildContext context, CabangProvider provider, {CabangModel? cabang}) {
    final nameController = TextEditingController(text: cabang?.nama ?? '');
    final alamatController = TextEditingController(text: cabang?.alamat ?? '');
    final kontakController = TextEditingController(text: cabang?.kontak ?? '');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(cabang == null ? 'Tambah Cabang' : 'Edit Cabang'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Semantics(
                  identifier: 'input_nama_cabang',
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nama Cabang'),
                  ),
                ),
                Semantics(
                  identifier: 'input_alamat_cabang',
                  child: TextField(
                    controller: alamatController,
                    decoration: const InputDecoration(labelText: 'Alamat'),
                  ),
                ),
                Semantics(
                  identifier: 'input_kontak_cabang',
                  child: TextField(
                    controller: kontakController,
                    decoration: const InputDecoration(labelText: 'Kontak'),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final data = {
                  'nama': nameController.text,
                  'alamat': alamatController.text,
                  'kontak': kontakController.text,
                };
                bool success;
                if (cabang == null) {
                  success = await provider.createCabang(data);
                } else {
                  success = await provider.updateCabang(cabang.id, data);
                }
                if (dialogContext.mounted) {
                  if (success) {
                    Navigator.pop(dialogContext);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cabang disimpan')));
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(provider.error ?? 'Gagal menyimpan')));
                    }
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, CabangProvider provider, int id) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Cabang?'),
        content: const Text('Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            onPressed: () async {
              final success = await provider.deleteCabang(id);
              if (dialogContext.mounted) {
                if (success) {
                  Navigator.pop(dialogContext);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cabang dihapus')));
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(provider.error ?? 'Gagal menghapus')));
                  }
                }
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
