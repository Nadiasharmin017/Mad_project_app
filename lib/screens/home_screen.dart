import 'package:flutter/material.dart';
import '../widgets/section_card.dart';
import 'books_screen.dart';
import 'location_screen.dart';
import 'profile_screen.dart';
import 'journal_screen.dart';


// import journal_screen.dart, profile_screen.dart if you have them

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  late final List<Widget> pages;

@override
void initState() {
  super.initState();
  pages = [
    _homePage(),           // Home
    const JournalScreen(), // Journal
    BooksScreen(),         // Books
    ProfileScreen(),       // ✅ PROFILE NOW CONNECTED
  ];
}

  Widget _placeholder(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _homePage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        SectionCard(
          title: "Buddha",
          subtitle: "Buddhist philosophy",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    BooksScreen(initialCategory: "Buddhism"),
              ),
            );
          },
        ),
        SectionCard(
          title: "Plato",
          subtitle: "Greek philosophy",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    BooksScreen(initialCategory: "Plato"),
              ),
            );
          },
        ),
        SectionCard(
          title: "Marcus Aurelius",
          subtitle: "Stoicism",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    BooksScreen(initialCategory: "Stoicism"),
              ),
            );
          },
        ),
        SectionCard(
          title: "Ethics",
          subtitle: "Moral philosophy",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    BooksScreen(initialCategory: "Ethics"),
              ),
            );
          },
        ),
        SectionCard(
          title: "Philosophical Locations",
          subtitle: "Historic places",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LocationScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          "PHILOSOPHY",
          style: TextStyle(
            color: Color(0xFFC9A36A),
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF121212),
      ),
      body: pages[index], // 🔥 THIS IS THE KEY FIX
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF121212),
        selectedItemColor: const Color(0xFFC9A36A),
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }
}
