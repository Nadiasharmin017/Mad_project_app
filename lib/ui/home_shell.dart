import 'package:flutter/material.dart';
import '../core/colors.dart';
import 'tabs/home_tab.dart';
import 'tabs/journal_tab.dart';
import 'tabs/books_tab.dart';
import 'tabs/profile_tab.dart';
import 'tabs/locations_tab.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  final tabs = const [
    HomeTab(),
    JournalTab(),
    BooksTab(),
    LocationsTab(),   // ✅ LOCATION SECTION
    ProfileTab(),     // ✅ NOTIFICATION SETTINGS HERE
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index, // ✅ FIXED
        onDestinationSelected: (v) => setState(() => index = v), // ✅ FIXED
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.wb_sunny_outlined),
            label: "Today",
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_note),
            label: "Journal",
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book),
            label: "Books",
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            label: "Places",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
