import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/nametag_provider.dart';
import '../../constants/app_colors.dart';
import '../main_drawer.dart';

class NametagScreen extends StatefulWidget {
  const NametagScreen({super.key});

  @override
  State<NametagScreen> createState() => _NametagScreenState();
}

class _NametagScreenState extends State<NametagScreen> {
  List<int> _selectedIds = [];
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NametagProvider>(context, listen: false).fetchNametags();
    });
  }

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
      _isSelectionMode = _selectedIds.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NametagProvider>();
    final tags = provider.nametags;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_isSelectionMode ? '${_selectedIds.length} Dipilih' : 'ID Card / Name Tags', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        leading: _isSelectionMode ? IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => setState(() { _selectedIds.clear(); _isSelectionMode = false; }),
        ) : null,
        actions: [
          if (_isSelectionMode)
            IconButton(
              icon: const Icon(Icons.select_all),
              onPressed: () {
                setState(() {
                  if (_selectedIds.length == tags.length) {
                    _selectedIds.clear();
                    _isSelectionMode = false;
                  } else {
                    _selectedIds = tags.map((t) => t.id).toList();
                  }
                });
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh, color: AppColors.primary),
              onPressed: provider.fetchNametags,
            )
        ],
      ),
      drawer: _isSelectionMode ? null : const MainDrawer(),
      body: provider.isLoading && tags.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : tags.isEmpty
              ? _buildEmptyState(provider)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: tags.length,
                  itemBuilder: (context, index) {
                    final tag = tags[index];
                    final isSelected = _selectedIds.contains(tag.id);
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: isSelected ? AppColors.primary : Colors.transparent, width: 2),
                      ),
                      child: ListTile(
                        onTap: () {
                          if (_isSelectionMode) {
                            _toggleSelection(tag.id);
                          }
                        },
                        onLongPress: () {
                          _toggleSelection(tag.id);
                        },
                        leading: isSelected 
                          ? const CircleAvatar(backgroundColor: AppColors.primary, child: Icon(Icons.check, color: Colors.white))
                          : const CircleAvatar(backgroundColor: Colors.indigo, child: Icon(Icons.badge, color: Colors.white)),
                        title: Text(tag.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Barcode: ${tag.barcode}'),
                      ),
                    );
                  },
                ),
      floatingActionButton: _selectedIds.isEmpty ? null : FloatingActionButton.extended(
        onPressed: () => _generateNametags(context, provider),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.auto_awesome, color: Colors.white),
        label: const Text('Generate Terpilih', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildEmptyState(NametagProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.badge_outlined, size: 80, color: AppColors.primary.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text('Belum ada Siswa', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _generateNametags(BuildContext context, NametagProvider provider) async {
    final queryParams = _selectedIds.map((id) => 'user_ids[]=$id').join('&');
    final url = Uri.parse('https://studycenter.seriusman.shop/admin/nametags/generate?$queryParams&auto_print=1');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
      if (mounted) {
        setState(() {
          _selectedIds.clear();
          _isSelectionMode = false;
        });
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal membuka URL Web')));
    }
  }
}
