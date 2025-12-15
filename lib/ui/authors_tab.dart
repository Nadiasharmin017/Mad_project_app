import 'package:flutter/material.dart';
import '../../core/colors.dart';

class AuthorsTab extends StatelessWidget {
  const AuthorsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authors = [
      "Marcus Aurelius",
      "Epictetus",
      "Seneca",
      "Zeno of Citium",
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: authors.length,
      itemBuilder: (_, i) {
        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            authors[i],
            style: const TextStyle(
              
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
