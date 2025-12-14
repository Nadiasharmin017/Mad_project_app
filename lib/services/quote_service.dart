import "dart:convert";
import "package:flutter/services.dart";
import "package:http/http.dart" as http;
import "package:intl/intl.dart";
import "package:shared_preferences/shared_preferences.dart";
import "../app_config.dart";
import "../db/app_db.dart";
import "../models/quote.dart";

class QuoteService {
  static const _prefKeyDate = "quote_date";
  static const _prefKeyText = "quote_text";
  static const _prefKeyAuthor = "quote_author";

  String _todayKey() => DateFormat("yyyy-MM-dd").format(DateTime.now());

  Future<Quote> getTodayQuote() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _todayKey();

    // Return cached daily quote (stable for the day)
    if (prefs.getString(_prefKeyDate) == today) {
      return Quote(
        text: prefs.getString(_prefKeyText) ?? "",
        author: prefs.getString(_prefKeyAuthor) ?? "Unknown",
        date: DateTime.now(),
      );
    }

    // Try ZenQuotes
    try {
      final res = await http.get(Uri.parse(AppConfig.zenQuotesUrl));
      if (res.statusCode == 200) {
        final jsonList = json.decode(res.body) as List<dynamic>;
        final item = jsonList.first as Map<String, dynamic>;
        final text = item["q"]?.toString() ?? "";
        final author = item["a"]?.toString() ?? "Unknown";

        final q = Quote(text: text, author: author, date: DateTime.now());
        await _persistDaily(prefs, today, q);
        await AppDb.instance.upsertQuote(q);
        return q;
      }
    } catch (_) {}

    // Fallback local JSON
    final fallback = await _fallbackQuote();
    final q = Quote(text: fallback.$1, author: fallback.$2, date: DateTime.now());
    await _persistDaily(prefs, today, q);
    await AppDb.instance.upsertQuote(q);
    return q;
  }

  Future<void> _persistDaily(SharedPreferences prefs, String today, Quote q) async {
    await prefs.setString(_prefKeyDate, today);
    await prefs.setString(_prefKeyText, q.text);
    await prefs.setString(_prefKeyAuthor, q.author);
  }

  Future<(String, String)> _fallbackQuote() async {
    final raw = await rootBundle.loadString("assets/quotes_fallback.json");
    final list = (json.decode(raw) as List<dynamic>).cast<Map<String, dynamic>>();
    // simple deterministic pick by day
    final idx = DateTime.now().day % list.length;
    final item = list[idx];
    return (item["q"].toString(), item["a"].toString());
  }
}
