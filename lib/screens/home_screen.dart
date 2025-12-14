import "package:flutter/material.dart";
import "../widgets/section_card.dart";
import "books_screen.dart";
import "location_screen.dart";
import "quote_history_screen.dart";
import "../services/quote_service.dart";
import "../services/notification_service.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? todayQuote;

  @override
  void initState() {
    super.initState();
    _loadQuote();
  }

  Future<void> _loadQuote() async {
    final q = await QuoteService().getTodayQuote();
    setState(() => todayQuote = "“${q.text}” — ${q.author}");
  }

  Future<void> _notifyNow() async {
    final q = await QuoteService().getTodayQuote();
    await NotificationService.instance.showDailyQuoteNow(
      title: "Daily Philosophy",
      body: "“${q.text}” — ${q.author}",
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Notification sent.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Philosophy App")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Today’s Quote", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(todayQuote ?? "Loading..."),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _notifyNow,
                        icon: const Icon(Icons.notifications),
                        label: const Text("Notify now"),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const QuoteHistoryScreen()),
                        ),
                        child: const Text("History"),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SectionCard(
            title: "Book Recommendations",
            subtitle: "Explore philosophy books (Google Books API)",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BooksScreen())),
          ),
          SectionCard(
            title: "Daily Philosophical Location",
            subtitle: "Wikipedia + Google Places + Static Maps",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LocationScreen())),
          ),
        ],
      ),
    );
  }
}
