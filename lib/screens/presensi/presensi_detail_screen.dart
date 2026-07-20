import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/presensi_model.dart';

class PresensiDetailScreen extends StatelessWidget {
  final PresensiModel presensi;

  const PresensiDetailScreen({super.key, required this.presensi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detail Presensi', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (presensi.photoUrl != null && presensi.photoUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  presensi.photoUrl!,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 250,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            
            _buildDetailItem('Cabang', presensi.cabang, Icons.apartment),
            _buildDetailItem('Kelas', presensi.kelas, Icons.class_),
            _buildDetailItem('Mata Pelajaran', presensi.mapel, Icons.menu_book),
            _buildDetailItem('Tanggal', presensi.date, Icons.calendar_today),
            _buildDetailItem('Waktu', '${presensi.startTime} - ${presensi.endTime}', Icons.access_time),
            
            if (presensi.note != null && presensi.note!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('Catatan:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(presensi.note!),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
