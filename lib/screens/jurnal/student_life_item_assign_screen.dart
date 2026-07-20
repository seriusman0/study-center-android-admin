import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/user_provider.dart';
import '../../providers/life_item_provider.dart';
import '../../models/user_model.dart';
import '../../models/life_item_model.dart';
import '../main_drawer.dart';

class StudentLifeItemAssignScreen extends StatefulWidget {
  const StudentLifeItemAssignScreen({super.key});

  @override
  State<StudentLifeItemAssignScreen> createState() => _StudentLifeItemAssignScreenState();
}

class _StudentLifeItemAssignScreenState extends State<StudentLifeItemAssignScreen> {
  UserModel? _selectedStudent;
  List<int> _assignedItemIds = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchUsers(); // ideally fetch only students
      context.read<LifeItemProvider>().fetchLifeItems();
    });
  }

  Future<void> _onStudentSelected(UserModel? student) async {
    setState(() {
      _selectedStudent = student;
      _assignedItemIds = [];
    });
    
    if (student != null) {
      final ids = await context.read<LifeItemProvider>().fetchStudentAssignments(student.id);
      setState(() {
        _assignedItemIds = ids;
      });
    }
  }

  Future<void> _saveAssignments() async {
    if (_selectedStudent == null) return;

    setState(() => _isSaving = true);
    final success = await context.read<LifeItemProvider>().syncStudentAssignments(_selectedStudent!.id, _assignedItemIds);
    setState(() => _isSaving = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil menyimpan penugasan!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menyimpan penugasan.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProv = context.watch<UserProvider>();
    final lifeProv = context.watch<LifeItemProvider>();
    
    // Filter users to only those who are students (have role 'student' or are active)
    final students = userProv.users.where((u) => u.roles.any((r) => r.name == 'student')).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Assign Life Item', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _selectedStudent != null && !_isSaving ? _saveAssignments : null,
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: userProv.isLoading || lifeProv.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButtonFormField<UserModel>(
                    decoration: const InputDecoration(
                      labelText: 'Pilih Siswa',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedStudent,
                    items: students.map((s) {
                      return DropdownMenuItem(
                        value: s,
                        child: Text('${s.name} (${s.username})'),
                      );
                    }).toList(),
                    onChanged: _onStudentSelected,
                  ),
                ),
                if (_selectedStudent != null)
                  Expanded(
                    child: ListView.builder(
                      itemCount: lifeProv.items.length,
                      itemBuilder: (context, index) {
                        final item = lifeProv.items[index];
                        final isAssigned = _assignedItemIds.contains(item.id);

                        return CheckboxListTile(
                          title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(item.description),
                          value: isAssigned,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _assignedItemIds.add(item.id);
                              } else {
                                _assignedItemIds.remove(item.id);
                              }
                            });
                          },
                        );
                      },
                    ),
                  )
                else
                  const Expanded(
                    child: Center(
                      child: Text('Silakan pilih siswa terlebih dahulu.'),
                    ),
                  ),
              ],
            ),
    );
  }
}
