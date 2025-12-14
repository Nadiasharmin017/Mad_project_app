import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "../models/quote.dart";

class AppDb {
  static final AppDb instance = AppDb._();
  AppDb._();

  Database? _db;

  Future<Database> get db async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), "philosophy_app.db");
    return openDatabase(
      path,
      version: 1,
      onCreate: (d, v) async {
        await d.execute("""
          CREATE TABLE quotes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            text TEXT NOT NULL,
            author TEXT NOT NULL,
            date TEXT NOT NULL UNIQUE
          );
        """);

        await d.execute("""
          CREATE TABLE favorites(
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            authors TEXT NOT NULL,
            thumbnail TEXT
          );
        """);
      },
    );
  }

  Future<void> upsertQuote(Quote q) async {
    final d = await db;
    await d.insert(
      "quotes",
      q.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Quote>> getQuoteHistory() async {
    final d = await db;
    final rows = await d.query("quotes", orderBy: "date DESC");
    return rows.map(Quote.fromMap).toList();
  }

  Future<void> addFavoriteBook({
    required String id,
    required String title,
    required String authors,
    String? thumbnail,
  }) async {
    final d = await db;
    await d.insert(
      "favorites",
      {"id": id, "title": title, "authors": authors, "thumbnail": thumbnail},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavoriteBook(String id) async {
    final d = await db;
    await d.delete("favorites", where: "id = ?", whereArgs: [id]);
  }

  Future<bool> isFavorite(String id) async {
    final d = await db;
    final rows = await d.query("favorites", where: "id = ?", whereArgs: [id], limit: 1);
    return rows.isNotEmpty;
  }
}
