import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'home_tab.dart';
import 'blog/blog_tab.dart';
import 'user/user_tab.dart';
import 'profile_tab.dart';
import 'main_drawer.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = [
    const HomeTab(),
    const BlogTab(),
    const UserTab(),
    const ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const MainDrawer(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.border, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              activeIcon: Icon(Icons.article),
              label: 'Blog',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'User',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 11),
          onTap: _onItemTapped,
          elevation: 0,
        ),
      ),
    );
  }
}
