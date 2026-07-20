import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/life_item_provider.dart';
import '../../constants/app_colors.dart';
import '../../models/life_item_model.dart';
import '../main_drawer.dart';

class JurnalLifeItemsScreen extends StatefulWidget {
  const JurnalLifeItemsScreen({super.key});

  @override
  State<JurnalLifeItemsScreen> createState() => _JurnalLifeItemsScreenState();
}

class _JurnalLifeItemsScreenState extends State<JurnalLifeItemsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LifeItemProvider>(context, listen: false).fetchLifeItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LifeItemProvider>();
    final items = provider.items;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Master Life Items', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
      ),
      drawer: const MainDrawer(),
      body: provider.isLoading && items.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: provider.fetchLifeItems,
              child: items.isEmpty
                  ? ListView(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Center(
                            child: Text('Tidak ada life item', style: TextStyle(color: AppColors.textSecondary)),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: item.isActive ? Colors.indigo : Colors.grey,
                              child: const Icon(Icons.assignment, color: Colors.white),
                            ),
                            title: Text(item.label, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('${item.kategori.toUpperCase()} - ${item.isDefault ? 'Default' : 'Kustom'}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: AppColors.primary),
                                  onPressed: () => _showDialog(context, provider, item: item),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: AppColors.error),
                                  onPressed: () => _confirmDelete(context, provider, item.id),
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

  void _showDialog(BuildContext context, LifeItemProvider provider, {LifeItemModel? item}) {
    final labelController = TextEditingController(text: item?.label ?? '');
    String kategori = item?.kategori ?? 'kerohanian';
    bool isDefault = item?.isDefault ?? false;
    bool isActive = item?.isActive ?? true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateBuilder) {
            return AlertDialog(
              title: Text(item == null ? 'Tambah Life Item' : 'Edit Life Item'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: labelController,
                      decoration: const InputDecoration(labelText: 'Label Item'),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: kategori.toLowerCase(),
                      decoration: const InputDecoration(labelText: 'Kategori'),
                      items: ['kerohanian', 'pendidikan', 'karakter']
                          .map((t) => DropdownMenuItem(value: t, child: Text(t.toUpperCase())))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setStateBuilder(() => kategori = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      title: const Text('Default untuk semua?'),
                      value: isDefault,
                      onChanged: (val) => setStateBuilder(() => isDefault = val),
                    ),
                    SwitchListTile(
                      title: const Text('Aktif?'),
                      value: isActive,
                      onChanged: (val) => setStateBuilder(() => isActive = val),
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
                      'label': labelController.text,
                      'kategori': kategori,
                      'is_default': isDefault,
                      'is_active': isActive,
                    };
                    bool success;
                    if (item == null) {
                      success = await provider.createLifeItem(data);
                    } else {
                      success = await provider.updateLifeItem(item.id, data);
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

  void _confirmDelete(BuildContext context, LifeItemProvider provider, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Item?'),
        content: const Text('Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            onPressed: () async {
              final success = await provider.deleteLifeItem(id);
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
