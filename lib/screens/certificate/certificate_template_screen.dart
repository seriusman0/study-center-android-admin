import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/certificate_provider.dart';
import '../main_drawer.dart';

class CertificateTemplateScreen extends StatefulWidget {
  const CertificateTemplateScreen({super.key});

  @override
  State<CertificateTemplateScreen> createState() => _CertificateTemplateScreenState();
}

class _CertificateTemplateScreenState extends State<CertificateTemplateScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CertificateProvider>().fetchTemplates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Template Sertifikat', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<CertificateProvider>().fetchTemplates(),
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: Consumer<CertificateProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.templates.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null && provider.templates.isEmpty) {
            return Center(
              child: Text(
                'Terjadi kesalahan:\n${provider.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (provider.templates.isEmpty) {
            return const Center(child: Text('Tidak ada template sertifikat.'));
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchTemplates(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.templates.length,
              itemBuilder: (context, index) {
                final template = provider.templates[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: template.isActive ? Colors.green : Colors.grey,
                      child: const Icon(Icons.workspace_premium, color: Colors.white),
                    ),
                    title: Text(template.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Ukuran: ${template.paperSize.toUpperCase()} (${template.orientation})\nStatus: ${template.isActive ? 'Aktif' : 'Nonaktif'}'),
                    isThreeLine: true,
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Detail Template Action
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pembuatan template di App belum tersedia, gunakan Web.')));
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
