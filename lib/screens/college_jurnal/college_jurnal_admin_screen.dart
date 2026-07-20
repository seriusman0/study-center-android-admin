import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/college_jurnal_provider.dart';
import '../main_drawer.dart';

class CollegeJurnalAdminScreen extends StatefulWidget {
  const CollegeJurnalAdminScreen({super.key});

  @override
  State<CollegeJurnalAdminScreen> createState() => _CollegeJurnalAdminScreenState();
}

class _CollegeJurnalAdminScreenState extends State<CollegeJurnalAdminScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CollegeJurnalProvider>().fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Admin Jurnal Kuliah', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimary,
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: 'Bible Chapters'),
              Tab(text: 'Life Items'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => context.read<CollegeJurnalProvider>().fetchAll(),
            ),
          ],
        ),
        drawer: const MainDrawer(),
        body: Consumer<CollegeJurnalProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.bibles.isEmpty && provider.items.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.error != null && provider.bibles.isEmpty && provider.items.isEmpty) {
              return Center(
                child: Text('Terjadi kesalahan:\n${provider.error}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
              );
            }

            return TabBarView(
              children: [
                _buildBibleTab(provider),
                _buildItemTab(provider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBibleTab(CollegeJurnalProvider provider) {
    if (provider.bibles.isEmpty) {
      return const Center(child: Text('Tidak ada data College Bible.'));
    }
    return RefreshIndicator(
      onRefresh: () => provider.fetchBibles(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.bibles.length,
        itemBuilder: (context, index) {
          final bible = provider.bibles[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: const Icon(Icons.book, color: AppColors.primary),
              ),
              title: Text('Hari ke-${bible.dayNo}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('PL: ${bible.plText}\nPB: ${bible.pbText}'),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemTab(CollegeJurnalProvider provider) {
    if (provider.items.isEmpty) {
      return const Center(child: Text('Tidak ada data College Items.'));
    }
    return RefreshIndicator(
      onRefresh: () => provider.fetchItems(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.items.length,
        itemBuilder: (context, index) {
          final item = provider.items[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: item.isActive ? Colors.orange : Colors.grey,
                child: const Icon(Icons.star, color: Colors.white),
              ),
              title: Text(item.label, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Kategori: ${item.kategori.toUpperCase()}\nResponse: ${item.responseType}'),
              isThreeLine: true,
              trailing: item.isDefault ? const Chip(label: Text('Default', style: TextStyle(fontSize: 10))) : null,
            ),
          );
        },
      ),
    );
  }
}
