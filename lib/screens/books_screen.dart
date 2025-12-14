import "package:flutter/material.dart";
import "package:cached_network_image/cached_network_image.dart";
import "../services/book_service.dart";
import "../db/app_db.dart";

class BooksScreen extends StatefulWidget {
  final String? initialCategory;

  const BooksScreen({
    super.key,
    this.initialCategory,
  });

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final categories = const [
    "Stoicism",
    "Buddhism",
    "Plato",
    "Ethics",
    "Existentialism"
  ];

  late String selected;
  bool loading = false;
  List books = [];

  @override
  void initState() {
    super.initState();
    selected = widget.initialCategory ?? "Stoicism";
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    final result = await BookService().searchByCategory(selected);
    setState(() {
      books = result;
      loading = false;
    });
  }

  Future<void> _toggleFav(book) async {
    final isFav = await AppDb.instance.isFavorite(book.id);
    if (isFav) {
      await AppDb.instance.removeFavoriteBook(book.id);
    } else {
      await AppDb.instance.addFavoriteBook(
        id: book.id,
        title: book.title,
        authors: book.authors,
        thumbnail: book.thumbnail,
      );
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Explorer")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                const Text("Category: "),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    value: selected,
                    isExpanded: true,
                    items: categories
                        .map((c) =>
                            DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() => selected = v);
                      _load();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (loading) const LinearProgressIndicator(),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: books.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final b = books[i];
                  return FutureBuilder<bool>(
                    future: AppDb.instance.isFavorite(b.id),
                    builder: (context, snap) {
                      final fav = snap.data ?? false;
                      return ListTile(
                        leading: b.thumbnail == null
                            ? const Icon(Icons.book)
                            : CachedNetworkImage(
                                imageUrl: b.thumbnail!,
                                width: 45,
                                fit: BoxFit.cover,
                              ),
                        title: Text(b.title),
                        subtitle: Text(b.authors),
                        trailing: IconButton(
                          icon: Icon(
                              fav ? Icons.favorite : Icons.favorite_border),
                          onPressed: () => _toggleFav(b),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
