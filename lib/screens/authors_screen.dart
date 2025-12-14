import 'package:flutter/material.dart';

class AuthorsScreen extends StatelessWidget {
  const AuthorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authors = [
      "Epictetus",
      "Marcus Aurelius",
      "Seneca",
      "Plato",
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("AUTHORS"),
        backgroundColor: const Color(0xFF121212),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: authors.length,
        itemBuilder: (_, i) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFC9A36A).withOpacity(0.4),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              authors[i],
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFC9A36A),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }
}
