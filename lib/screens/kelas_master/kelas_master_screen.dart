import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/kelas_master_provider.dart';
import '../../constants/app_colors.dart';
import '../../models/kelas_master_model.dart';
import '../../providers/blog_provider.dart';
import '../main_drawer.dart';

class KelasMasterScreen extends StatefulWidget {
  const KelasMasterScreen({super.key});

  @override
  State<KelasMasterScreen> createState() => _KelasMasterScreenState();
}

class _KelasMasterScreenState extends State<KelasMasterScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<KelasMasterProvider>(context, listen: false).fetchKelasMaster();
      Provider.of<BlogProvider>(context, listen: false).fetchCabangs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<KelasMasterProvider>();
    final listKelas = provider.kelas;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Kelas Master', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
      ),
      drawer: const MainDrawer(),
      body: provider.isLoading && listKelas.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: provider.fetchKelasMaster,
              child: listKelas.isEmpty
                  ? ListView(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Center(
                            child: Text('Tidak ada kelas', style: TextStyle(color: AppColors.textSecondary)),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: listKelas.length,
                      itemBuilder: (context, index) {
                        final kelas = listKelas[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: kelas.isActive ? AppColors.primaryLight.withOpacity(0.1) : Colors.grey.shade200,
                              child: Icon(Icons.class_, color: kelas.isActive ? AppColors.primaryLight : Colors.grey),
                            ),
                            title: Text(kelas.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('${kelas.cabangNama ?? 'Semua Cabang'} - ${kelas.isActive ? 'Aktif' : 'Non-aktif'}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: AppColors.primary),
                                  onPressed: () => _showDialog(context, provider, kelas: kelas),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: AppColors.error),
                                  onPressed: () => _confirmDelete(context, provider, kelas.id),
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

  void _showDialog(BuildContext context, KelasMasterProvider provider, {KelasMasterModel? kelas}) {
    final blogProvider = Provider.of<BlogProvider>(context, listen: false);
    final nameController = TextEditingController(text: kelas?.nama ?? '');
    final descController = TextEditingController(text: kelas?.deskripsi ?? '');
    bool isActive = kelas?.isActive ?? true;
    int? selectedCabangId = kelas?.cabangId;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateBuilder) {
            return AlertDialog(
              title: Text(kelas == null ? 'Tambah Kelas' : 'Edit Kelas'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Nama Kelas'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      value: selectedCabangId,
                      decoration: const InputDecoration(labelText: 'Pilih Cabang'),
                      items: blogProvider.cabangs.map((c) => DropdownMenuItem(value: c.id, child: Text(c.nama))).toList(),
                      onChanged: (val) {
                        setStateBuilder(() {
                          selectedCabangId = val;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(labelText: 'Deskripsi'),
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
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedCabangId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cabang harus dipilih'), backgroundColor: AppColors.error));
                      return;
                    }
                    final data = {
                      'nama': nameController.text,
                      'deskripsi': descController.text,
                      'is_active': isActive,
                      'cabang_id': selectedCabangId,
                    };
                    bool success;
                    if (kelas == null) {
                      success = await provider.createKelasMaster(data);
                    } else {
                      success = await provider.updateKelasMaster(kelas.id, data);
                    }
                    if (mounted && success) {
                      Navigator.pop(context);
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

  void _confirmDelete(BuildContext context, KelasMasterProvider provider, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Kelas?'),
        content: const Text('Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            onPressed: () async {
              final success = await provider.deleteKelasMaster(id);
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
