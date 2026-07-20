import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/blog_provider.dart';
import '../../providers/kelas_master_provider.dart';
import '../../providers/mata_pelajaran_provider.dart';
import '../../providers/presensi_provider.dart';
import '../../providers/user_provider.dart';

class PresensiCreateScreen extends StatefulWidget {
  const PresensiCreateScreen({super.key});

  @override
  State<PresensiCreateScreen> createState() => _PresensiCreateScreenState();
}

class _PresensiCreateScreenState extends State<PresensiCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  int? _selectedKelasId;
  int? _selectedCabangId;
  int? _selectedMentorId;
  String? _selectedMataPelajaran;

  final _catatanController = TextEditingController();

  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  List<dynamic> _students = [];
  Map<int, String> _studentStatus = {};
  bool _loadingStudents = false;

  Future<void> _loadStudents() async {
    if (_selectedKelasId == null) return;
    setState(() => _loadingStudents = true);
    try {
      final provider = Provider.of<PresensiProvider>(context, listen: false);
      final params = <String, dynamic>{'kelas_id': _selectedKelasId};
      if (_selectedCabangId != null) params['cabang_id'] = _selectedCabangId;
      final response = await provider.apiService.dio.get('/presensi/students/search', queryParameters: params);
      setState(() {
        _students = response.data['data'] as List;
        _studentStatus.clear();
        for (var s in _students) {
          _studentStatus[s['id']] = 'hadir';
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat siswa: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingStudents = false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BlogProvider>(context, listen: false).fetchCabangs();
      Provider.of<KelasMasterProvider>(context, listen: false).fetchKelasMaster();
      Provider.of<MataPelajaranProvider>(context, listen: false).fetchMataPelajaran();
      Provider.of<UserProvider>(context, listen: false).fetchUsers(role: 'mentor');
    });
  }

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal memilih gambar'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null || _startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Waktu dan tanggal harus diisi!'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
    final endMinutes = _endTime!.hour * 60 + _endTime!.minute;
    if (endMinutes <= startMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jam selesai harus setelah jam mulai!'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto kegiatan wajib diunggah!'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_studentStatus.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal satu siswa!'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final provider = Provider.of<PresensiProvider>(context, listen: false);
    final data = <String, dynamic>{
      'tanggal': _selectedDate!.toIso8601String().split('T')[0],
      'jam_mulai': '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}',
      'jam_selesai': '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}',
      'cabang_id': _selectedCabangId,
      'kelas_id': _selectedKelasId,
      'materi': _catatanController.text.isEmpty ? '-' : _catatanController.text,
      'mentor_id': _selectedMentorId,
      'foto_path': _selectedImage!.path,
    };

    int index = 0;
    _studentStatus.forEach((id, status) {
      data['student_ids[$index]'] = id;
      data['student_status[$id]'] = status;
      index++;
    });

    final success = await provider.createPresensi(data);

    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Presensi berhasil disimpan!')),
      );
      Navigator.of(context).pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Gagal menyimpan presensi'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final blogProvider = context.watch<BlogProvider>();
    final kelasProvider = context.watch<KelasMasterProvider>();
    final mapelProvider = context.watch<MataPelajaranProvider>();
    final userProvider = context.watch<UserProvider>();
    final mentors = userProvider.users.where((u) => u.roles.any((r) => r.name.toLowerCase() == 'mentor')).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Catat Presensi Siswa', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Mentor
              DropdownButtonFormField<int>(
                value: _selectedMentorId,
                decoration: InputDecoration(
                  labelText: 'Pilih Mentor',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: mentors.map((m) => DropdownMenuItem(value: m.id, child: Text(m.name))).toList(),
                onChanged: (val) => setState(() => _selectedMentorId = val),
                validator: (val) => val == null ? 'Mentor wajib dipilih' : null,
              ),
              const SizedBox(height: 12),

              // Tanggal
              ListTile(
                title: Text(_selectedDate == null ? 'Pilih Tanggal' : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                leading: const Icon(Icons.calendar_today, color: AppColors.primary),
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
                onTap: _pickDate,
              ),
              const SizedBox(height: 12),

              // Waktu
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(_startTime == null ? 'Jam Mulai' : _startTime!.format(context)),
                      leading: const Icon(Icons.access_time, color: AppColors.primary),
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
                      onTap: () => _pickTime(true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ListTile(
                      title: Text(_endTime == null ? 'Jam Selesai' : _endTime!.format(context)),
                      leading: const Icon(Icons.access_time_filled, color: AppColors.primary),
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
                      onTap: () => _pickTime(false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Cabang
              DropdownButtonFormField<int>(
                value: _selectedCabangId,
                decoration: InputDecoration(
                  labelText: 'Pilih Cabang',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: blogProvider.cabangs.map((c) => DropdownMenuItem(value: c.id, child: Text(c.nama))).toList(),
                onChanged: (val) => setState(() => _selectedCabangId = val),
                validator: (val) => val == null ? 'Cabang wajib dipilih' : null,
              ),
              const SizedBox(height: 12),

              // Kelas
              DropdownButtonFormField<int>(
                value: _selectedKelasId,
                decoration: InputDecoration(
                  labelText: 'Pilih Kelas',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: kelasProvider.kelas.map((k) => DropdownMenuItem<int>(value: k.id, child: Text(k.nama))).toList(),
                onChanged: (val) {
                  setState(() => _selectedKelasId = val);
                  _loadStudents();
                },
                validator: (val) => val == null ? 'Kelas wajib dipilih' : null,
              ),
              const SizedBox(height: 12),

              // Daftar Siswa
              if (_loadingStudents)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_students.isNotEmpty) ...[
                const Text('Daftar Siswa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _students.length,
                    separatorBuilder: (c, i) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final s = _students[index];
                      final id = s['id'] as int;
                      final status = _studentStatus[id] ?? 'hadir';
                      final isSelected = _studentStatus.containsKey(id);
                      return CheckboxListTile(
                        title: Text(s['name']),
                        subtitle: isSelected
                            ? DropdownButton<String>(
                                value: status,
                                isDense: true,
                                items: ['hadir', 'izin', 'sakit', 'alpha']
                                    .map((st) => DropdownMenuItem(value: st, child: Text(st.toUpperCase())))
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _studentStatus[id] = val);
                                },
                              )
                            : null,
                        value: isSelected,
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              _studentStatus[id] = 'hadir';
                            } else {
                              _studentStatus.remove(id);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Mata Pelajaran
              DropdownButtonFormField<String>(
                value: _selectedMataPelajaran,
                decoration: InputDecoration(
                  labelText: 'Mata Pelajaran',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: mapelProvider.mapels.map((m) => DropdownMenuItem(value: m.name, child: Text(m.name))).toList(),
                onChanged: (val) => setState(() => _selectedMataPelajaran = val),
                validator: (val) => val == null ? 'Mata pelajaran wajib dipilih' : null,
              ),
              const SizedBox(height: 16),

              // Foto Kegiatan
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    if (_selectedImage == null)
                      TextButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.add_a_photo, color: AppColors.primary),
                        label: const Text('Upload Foto Kegiatan', style: TextStyle(color: AppColors.primary)),
                      )
                    else
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(_selectedImage!.path),
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _pickImage,
                            icon: const Icon(Icons.sync, color: AppColors.primary),
                            label: const Text('Ganti Foto', style: TextStyle(color: AppColors.primary)),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Materi / Catatan
              TextFormField(
                controller: _catatanController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Materi / Catatan',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                height: 50,
                child: Consumer<PresensiProvider>(
                  builder: (context, provider, _) => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: provider.isLoading ? null : _submit,
                    child: provider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Simpan Presensi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
