import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../models/user_model.dart';
import '../../providers/pendaftaran_provider.dart';

class PendaftaranDetailScreen extends StatelessWidget {
  final UserModel user;

  const PendaftaranDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final profile = user.studentProfile;
    final isValidated = profile?.status == 'diterima';
    final isRejected = profile?.status == 'ditolak';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detail Pendaftaran', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primary,
                    backgroundImage: profile?.photo != null 
                      ? NetworkImage('https://studycenter.seriusman.shop/storage/${profile!.photo}')
                      : null,
                    child: profile?.photo == null ? const Icon(Icons.person, size: 40, color: Colors.white) : null,
                  ),
                  const SizedBox(height: 16),
                  Text(user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(profile?.schoolName ?? 'Tidak ada nama sekolah', style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  Chip(
                    label: Text((profile?.status ?? 'pending').toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    backgroundColor: isValidated ? Colors.green : (isRejected ? Colors.red : Colors.orange),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Data Pendaftaran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            _buildDetailRow('Email', user.email ?? '-'),
            _buildDetailRow('Asal Sekolah', profile?.schoolName ?? '-'),
            _buildDetailRow('Kelas', profile?.gradeClass ?? '-'),
            _buildDetailRow('Tahun Masuk', profile?.entryYear?.toString() ?? '-'),
            _buildDetailRow('Nomor HP', profile?.studentPhone ?? '-'),
            _buildDetailRow('Mata Pelajaran', profile?.mataPelajaran?.join(', ') ?? '-'),
            const SizedBox(height: 32),
            if (!isValidated && !isRejected) ...[
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _showValidasiDialog(context, 'diterima', 'Terima Pendaftaran'),
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text('Terima & Validasi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: const BorderSide(color: Colors.orange),
                ),
                onPressed: () => _showValidasiDialog(context, 'perbaikan', 'Minta Perbaikan'),
                icon: const Icon(Icons.edit, color: Colors.orange),
                label: const Text('Perlu Perbaikan', style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: const BorderSide(color: Colors.red),
                ),
                onPressed: () => _showValidasiDialog(context, 'ditolak', 'Tolak Pendaftaran'),
                icon: const Icon(Icons.close, color: Colors.red),
                label: const Text('Tolak', style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showValidasiDialog(BuildContext context, String status, String title) {
    final catatanController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: catatanController,
          decoration: const InputDecoration(
            labelText: 'Catatan (Opsional)',
            hintText: 'Misal: Foto tidak jelas',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _handleValidasi(context, status, catatanAdmin: catatanController.text.isNotEmpty ? catatanController.text : null);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _handleValidasi(BuildContext context, String status, {String? catatanAdmin}) async {
    final provider = context.read<PendaftaranProvider>();
    final success = await provider.validasiPendaftar(user.id, status, catatanAdmin: catatanAdmin);
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pendaftaran $status!')));
      Navigator.pop(context);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: ${provider.error}')));
    }
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title, style: const TextStyle(color: AppColors.textSecondary))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
