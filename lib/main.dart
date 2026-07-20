import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/app_colors.dart';
import 'services/api_service.dart';
import 'providers/auth_provider.dart';
import 'providers/blog_provider.dart';
import 'providers/user_provider.dart';
import 'providers/cabang_provider.dart';
import 'providers/mata_pelajaran_provider.dart';
import 'providers/kelas_master_provider.dart';
import 'providers/presensi_provider.dart';
import 'providers/life_item_provider.dart';
import 'providers/bible_schedule_provider.dart';
import 'providers/weekly_verse_provider.dart';
import 'providers/role_provider.dart';
import 'providers/nametag_provider.dart';
import 'providers/pendaftaran_provider.dart';
import 'providers/certificate_provider.dart';
import 'providers/college_jurnal_provider.dart';
import 'providers/mentor_presensi_provider.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Instantiate the shared singletons
    final apiService = ApiService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(apiService),
        ),
        ChangeNotifierProvider<BlogProvider>(
          create: (_) => BlogProvider(apiService),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(apiService),
        ),
        ChangeNotifierProvider<CabangProvider>(
          create: (_) => CabangProvider(apiService),
        ),
        ChangeNotifierProvider<MataPelajaranProvider>(
          create: (_) => MataPelajaranProvider(apiService),
        ),
        ChangeNotifierProvider<KelasMasterProvider>(
          create: (_) => KelasMasterProvider(apiService),
        ),
        ChangeNotifierProvider<PresensiProvider>(
          create: (_) => PresensiProvider(apiService),
        ),
        ChangeNotifierProvider<MentorPresensiProvider>(
          create: (_) => MentorPresensiProvider(apiService),
        ),
        ChangeNotifierProvider<LifeItemProvider>(
          create: (_) => LifeItemProvider(apiService),
        ),
        ChangeNotifierProvider<BibleScheduleProvider>(
          create: (_) => BibleScheduleProvider(apiService),
        ),
        ChangeNotifierProvider<WeeklyVerseProvider>(
          create: (_) => WeeklyVerseProvider(apiService),
        ),
        ChangeNotifierProvider<RoleProvider>(
          create: (_) => RoleProvider(apiService),
        ),
        ChangeNotifierProvider<NametagProvider>(
          create: (_) => NametagProvider(apiService),
        ),
        ChangeNotifierProvider<PendaftaranProvider>(
          create: (_) => PendaftaranProvider(apiService),
        ),
        ChangeNotifierProvider<CertificateProvider>(
          create: (_) => CertificateProvider(apiService),
        ),
        ChangeNotifierProvider<CollegeJurnalProvider>(
          create: (_) => CollegeJurnalProvider(apiService),
        ),
      ],
      child: MaterialApp(
        title: 'Study Center Admin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Plus Jakarta Sans',
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            secondary: AppColors.accent,
            background: AppColors.background,
          ),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: false,
          ),
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.checkAuthStatus();
    if (mounted) {
      setState(() {
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    final auth = context.watch<AuthProvider>();
    if (auth.isAuthenticated) {
      return const MainShell();
    } else {
      return const LoginScreen();
    }
  }
}
