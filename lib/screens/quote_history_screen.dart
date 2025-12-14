import "package:flutter/material.dart";
import "../db/app_db.dart";

class QuoteHistoryScreen extends StatelessWidget {
  const QuoteHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quote History")),
      body: FutureBuilder(
        future: AppDb.instance.getQuoteHistory(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final quotes = snapshot.data!;
          if (quotes.isEmpty) return const Center(child: Text("No quotes saved yet."));
          return ListView.separated(
            itemCount: quotes.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final q = quotes[i];
              final day = "${q.date.year}-${q.date.month.toString().padLeft(2, "0")}-${q.date.day.toString().padLeft(2, "0")}";
              return ListTile(
                title: Text("“${q.text}”"),
                subtitle: Text("${q.author} • $day"),
              );
            },
          );
        },
      ),
    );
  }
}
