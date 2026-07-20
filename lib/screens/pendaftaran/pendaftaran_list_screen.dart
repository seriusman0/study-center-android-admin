import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/pendaftaran_provider.dart';
import '../main_drawer.dart';
import 'pendaftaran_detail_screen.dart';

class PendaftaranListScreen extends StatefulWidget {
  const PendaftaranListScreen({super.key});

  @override
  State<PendaftaranListScreen> createState() => _PendaftaranListScreenState();
}

class _PendaftaranListScreenState extends State<PendaftaranListScreen> {
  String _selectedStatus = 'semua';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PendaftaranProvider>().fetchPendaftar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Validasi Pendaftaran', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        actions: [
          DropdownButton<String>(
            value: _selectedStatus,
            dropdownColor: Colors.white,
            icon: const Icon(Icons.filter_list, color: AppColors.primary),
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 'semua', child: Text('Semua')),
              DropdownMenuItem(value: 'pending', child: Text('Pending')),
              DropdownMenuItem(value: 'diterima', child: Text('Diterima')),
              DropdownMenuItem(value: 'ditolak', child: Text('Ditolak')),
              DropdownMenuItem(value: 'perbaikan', child: Text('Perbaikan')),
            ],
            onChanged: (val) {
              if (val != null) {
                setState(() => _selectedStatus = val);
                context.read<PendaftaranProvider>().fetchPendaftar(status: val);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<PendaftaranProvider>().fetchPendaftar(status: _selectedStatus);
            },
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: Consumer<PendaftaranProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.pendaftarList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null && provider.pendaftarList.isEmpty) {
            return Center(
              child: Text(
                'Terjadi kesalahan:\n${provider.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (provider.pendaftarList.isEmpty) {
            return const Center(child: Text('Tidak ada pendaftar.'));
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchPendaftar(status: _selectedStatus),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.pendaftarList.length,
              itemBuilder: (context, index) {
                final user = provider.pendaftarList[index];
                final profile = user.studentProfile;
                final isValidated = profile?.status == 'diterima';
                final isRejected = profile?.status == 'ditolak';

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isValidated ? Colors.green : (isRejected ? Colors.red : Colors.orange),
                      child: Icon(
                        isValidated ? Icons.check : (isRejected ? Icons.close : Icons.hourglass_empty),
                        color: Colors.white,
                      ),
                    ),
                    title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${profile?.schoolName ?? '-'}\nStatus: ${profile?.status?.toUpperCase() ?? '-'}'),
                    isThreeLine: true,
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => PendaftaranDetailScreen(user: user)),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
