import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/blog_provider.dart';
import '../../constants/app_colors.dart';
import 'user_detail_screen.dart';
import 'edit_user_screen.dart';
import '../main_drawer.dart';

class UserTab extends StatefulWidget {
  const UserTab({super.key});

  @override
  State<UserTab> createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {
  final _searchController = TextEditingController();
  String _selectedRole = 'Semua';
  int? _selectedCabangId;
  int _page = 1;

  final List<String> _rolesList = [
    'Semua',
    'Admin',
    'Mentor',
    'Student',
    'Fulltimer',
    'College',
    'Guest'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    // Make sure cabangs are loaded in BlogProvider for filter options
    Provider.of<BlogProvider>(context, listen: false).fetchCabangs();
    _fetchUsers();
  }

  void _fetchUsers() {
    Provider.of<UserProvider>(context, listen: false).fetchUsers(
      page: _page,
      query: _searchController.text,
      role: _selectedRole,
      cabangId: _selectedCabangId,
    );
  }

  void _onSearchChanged() {
    setState(() {
      _page = 1;
    });
    _fetchUsers();
  }

  void _onRoleFilterChanged(String? role) {
    if (role == null) return;
    setState(() {
      _selectedRole = role;
      _page = 1;
    });
    _fetchUsers();
  }

  void _onCabangFilterChanged(int? cabangId) {
    setState(() {
      _selectedCabangId = cabangId;
      _page = 1;
    });
    _fetchUsers();
  }

  void _goToPage(int page) {
    setState(() {
      _page = page;
    });
    _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final blogProvider = context.watch<BlogProvider>();
    final users = userProvider.users;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('Manajemen User', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const EditUserScreen()),
          );
          if (result == true) {
            _goToPage(1);
          }
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.person_add),
      ),
      body: Column(
        children: [
          // Filter card
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search Input
                TextField(
                  controller: _searchController,
                  onChanged: (_) => _onSearchChanged(),
                  decoration: InputDecoration(
                    hintText: 'Cari Nama, Email, Username...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.background,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Role and Branch Filter Dropdowns
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedRole,
                        decoration: InputDecoration(
                          labelText: 'Role',
                          labelStyle: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          filled: true,
                          fillColor: AppColors.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: _rolesList.map((role) {
                          return DropdownMenuItem(value: role, child: Text(role, style: const TextStyle(fontSize: 13)));
                        }).toList(),
                        onChanged: _onRoleFilterChanged,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<int?>(
                        value: _selectedCabangId,
                        decoration: InputDecoration(
                          labelText: 'Cabang',
                          labelStyle: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          filled: true,
                          fillColor: AppColors.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: [
                          const DropdownMenuItem<int?>(value: null, child: Text('Semua Cabang', style: TextStyle(fontSize: 13))),
                          ...blogProvider.cabangs.map((c) {
                            return DropdownMenuItem<int?>(value: c.id, child: Text(c.nama, style: const TextStyle(fontSize: 13)));
                          })
                        ],
                        onChanged: _onCabangFilterChanged,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // User count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              children: [
                Text(
                  'Ditemukan ${userProvider.totalUsersCount} User',
                  style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ),

          // User list
          Expanded(
            child: userProvider.isLoading && users.isEmpty
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : RefreshIndicator(
                    onRefresh: () async {
                      _goToPage(1);
                    },
                    color: AppColors.primary,
                    child: users.isEmpty
                        ? ListView(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(40.0),
                                child: Center(
                                  child: Text(
                                    'Tidak ada user ditemukan',
                                    style: TextStyle(color: AppColors.textSecondary),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];
                              final isUserActive = user.isActive;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: ListTile(
                                  onTap: () async {
                                    final result = await Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => UserDetailScreen(user: user)),
                                    );
                                    if (result == true) {
                                      _fetchUsers();
                                    }
                                  },
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  leading: CircleAvatar(
                                    backgroundColor: isUserActive
                                        ? AppColors.primary.withOpacity(0.1)
                                        : Colors.grey.shade200,
                                    child: Text(
                                      user.name.substring(0, 1).toUpperCase(),
                                      style: TextStyle(
                                        color: isUserActive ? AppColors.primary : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          user.name,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: isUserActive
                                              ? AppColors.primary.withOpacity(0.1)
                                              : Colors.red.shade50,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          isUserActive ? 'Aktif' : 'Non-aktif',
                                          style: TextStyle(
                                            color: isUserActive ? AppColors.primary : Colors.red,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        '@${user.username} | ${user.email ?? 'Tidak ada email'}',
                                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Wrap(
                                        spacing: 4,
                                        children: user.roles.map((r) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.accent.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              r.name.toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.accent,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                  trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                                ),
                              );
                            },
                          ),
                  ),
          ),

          // Pagination Controls
          if (userProvider.lastPage > 1)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _page > 1 ? () => _goToPage(_page - 1) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back, size: 16),
                        SizedBox(width: 4),
                        Text('Prev', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  Text(
                    'Halaman $_page dari ${userProvider.lastPage}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                  ),
                  ElevatedButton(
                    onPressed: _page < userProvider.lastPage ? () => _goToPage(_page + 1) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Row(
                      children: [
                        Text('Next', style: TextStyle(fontSize: 12)),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
