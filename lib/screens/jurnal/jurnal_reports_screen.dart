import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../main_drawer.dart';

class JurnalReportsScreen extends StatefulWidget {
  const JurnalReportsScreen({super.key});

  @override
  State<JurnalReportsScreen> createState() => _JurnalReportsScreenState();
}

class _JurnalReportsScreenState extends State<JurnalReportsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Laporan Jurnal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: AppColors.error),
            tooltip: 'Export PDF',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mempersiapkan Export PDF...')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.table_chart, color: Colors.green),
            tooltip: 'Export Excel',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mempersiapkan Export Excel...')));
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Siswa'),
            Tab(text: 'Mentor'),
          ],
        ),
      ),
      drawer: const MainDrawer(),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSiswaReport(),
          _buildMentorReport(),
        ],
      ),
    );
  }

  Widget _buildSiswaReport() {
    // Dummy Data
    final data = [
      {'nama': 'John Doe', 'cabang': 'Cabang Utama', 'poin': 150},
      {'nama': 'Jane Smith', 'cabang': 'Cabang Selatan', 'poin': 120},
      {'nama': 'Ahmad Rizal', 'cabang': 'Cabang Utama', 'poin': 90},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(item['nama'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(item['cabang'] as String),
            trailing: Chip(
              label: Text('${item['poin']} Poin', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              backgroundColor: Colors.green,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMentorReport() {
    // Dummy Data
    final data = [
      {'nama': 'Mentor A', 'kehadiran': 10, 'performa': 'Sangat Baik'},
      {'nama': 'Mentor B', 'kehadiran': 8, 'performa': 'Baik'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.orange,
              child: Icon(Icons.co_present, color: Colors.white),
            ),
            title: Text(item['nama'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Kehadiran: ${item['kehadiran']}x'),
            trailing: Text(item['performa'] as String, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }
}
