import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_colors.dart';
import '../../providers/certificate_provider.dart';
import '../main_drawer.dart';

class IssuedCertificateScreen extends StatefulWidget {
  const IssuedCertificateScreen({super.key});

  @override
  State<IssuedCertificateScreen> createState() => _IssuedCertificateScreenState();
}

class _IssuedCertificateScreenState extends State<IssuedCertificateScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CertificateProvider>().fetchIssued();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Sertifikat Keluar', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<CertificateProvider>().fetchIssued(),
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: Consumer<CertificateProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.issued.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null && provider.issued.isEmpty) {
            return Center(
              child: Text(
                'Terjadi kesalahan:\n${provider.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (provider.issued.isEmpty) {
            return const Center(child: Text('Belum ada sertifikat keluar.'));
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchIssued(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.issued.length,
              itemBuilder: (context, index) {
                final item = provider.issued[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.file_download_done, color: Colors.white),
                    ),
                    title: Text(item.student?.name ?? 'Unknown Student', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${item.namaKursus}\nTerbit: ${item.tanggalLulus}'),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.download, color: AppColors.primary),
                      onPressed: () async {
                        final url = Uri.parse('https://studycenter.seriusman.shop/api/admin/certificates/issued/${item.id}/download');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                      },
                    ),
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

