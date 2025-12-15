import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../widgets/quote_card.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text(
          "STOIC",
          style: TextStyle(
            color: AppColors.accent,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: const [
          SizedBox(height: 24),
          QuoteCard(
            quote:
                "You have power over your mind — not outside events. Realize this, and you will find strength.",
            author: "Marcus Aurelius",
            
          ),
        ],
      ),
    );
  }
}
