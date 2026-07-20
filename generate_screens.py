import os

screens = {
    "cabang/cabang_screen.dart": "CabangScreen",
    "mata_pelajaran/mata_pelajaran_screen.dart": "MataPelajaranScreen",
    "kelas_master/kelas_master_screen.dart": "KelasMasterScreen",
    "presensi/presensi_list_screen.dart": "PresensiListScreen",
    "presensi/presensi_detail_screen.dart": "PresensiDetailScreen",
    "jurnal/jurnal_life_items_screen.dart": "JurnalLifeItemsScreen",
    "jurnal/jurnal_bible_schedule_screen.dart": "JurnalBibleScheduleScreen",
    "jurnal/jurnal_weekly_verse_screen.dart": "JurnalWeeklyVerseScreen",
    "jurnal/jurnal_reports_screen.dart": "JurnalReportsScreen",
    "jurnal/student_life_item_assign_screen.dart": "StudentLifeItemAssignScreen",
    "mentor_presensi/mentor_presensi_list_screen.dart": "MentorPresensiListScreen",
    "mentor_presensi/mentor_presensi_report_screen.dart": "MentorPresensiReportScreen",
    "presensi/presensi_report_screen.dart": "PresensiReportScreen",
    "pendaftaran/pendaftaran_list_screen.dart": "PendaftaranListScreen",
    "pendaftaran/pendaftaran_detail_screen.dart": "PendaftaranDetailScreen",
    "nametag/nametag_screen.dart": "NameTagScreen",
    "roles_permissions/roles_screen.dart": "RolesScreen",
    "roles_permissions/permissions_screen.dart": "PermissionsScreen",
    "certificate/certificate_template_screen.dart": "CertificateTemplateScreen",
    "certificate/issued_certificate_screen.dart": "IssuedCertificateScreen",
    "college_jurnal/college_jurnal_admin_screen.dart": "CollegeJurnalAdminScreen"
}

template = """import 'package:flutter/material.dart';

class {class_name} extends StatelessWidget {{
  const {class_name}({{super.key}});

  @override
  Widget build(BuildContext context) {{
    return Scaffold(
      appBar: AppBar(
        title: const Text('{class_name}'),
      ),
      body: const Center(
        child: Text('{class_name} - Coming Soon'),
      ),
    );
  }}
}}
"""

for path, class_name in screens.items():
    full_path = f"lib/screens/{path}"
    os.makedirs(os.path.dirname(full_path), exist_ok=True)
    if not os.path.exists(full_path):
        with open(full_path, 'w') as f:
            f.write(template.format(class_name=class_name))

print("Created all placeholder screens.")
