import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/role_provider.dart';
import '../../constants/app_colors.dart';
import '../../models/role_model.dart';
import '../main_drawer.dart';

class RolesScreen extends StatefulWidget {
  const RolesScreen({super.key});

  @override
  State<RolesScreen> createState() => _RolesScreenState();
}

class _RolesScreenState extends State<RolesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RoleProvider>(context, listen: false).fetchRoles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RoleProvider>();
    final roles = provider.roles;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Manajemen Role', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
      ),
      drawer: const MainDrawer(),
      body: provider.isLoading && roles.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: provider.fetchRoles,
              child: roles.isEmpty
                  ? ListView(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Center(
                            child: Text('Tidak ada Role ditemukan', style: TextStyle(color: AppColors.textSecondary)),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: roles.length,
                      itemBuilder: (context, index) {
                        final role = roles[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.blueGrey,
                              child: Icon(Icons.security, color: Colors.white),
                            ),
                            title: Text(role.name.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(role.description ?? 'Tidak ada deskripsi'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: AppColors.primary),
                                  onPressed: () => _showDialog(context, provider, role: role),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: AppColors.error),
                                  onPressed: () => _confirmDelete(context, provider, role.id),
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

  void _showDialog(BuildContext context, RoleProvider provider, {RoleModel? role}) {
    final nameController = TextEditingController(text: role?.name ?? '');
    final descController = TextEditingController(text: role?.description ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(role == null ? 'Tambah Role' : 'Edit Role'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nama Role (e.g. admin, mentor)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Deskripsi Role'),
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
                  'name': nameController.text,
                  'description': descController.text,
                };
                bool success;
                if (role == null) {
                  success = await provider.createRole(data);
                } else {
                  success = await provider.updateRole(role.id, data);
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

  void _confirmDelete(BuildContext context, RoleProvider provider, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Role?'),
        content: const Text('Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            onPressed: () async {
              final success = await provider.deleteRole(id);
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
