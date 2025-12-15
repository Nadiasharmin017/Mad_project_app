import 'package:flutter/material.dart';
import '../../screens/books_screen.dart';

class BooksTab extends StatelessWidget {
  const BooksTab({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Reuse your original BooksScreen
    return const BooksScreen();
  }
}
