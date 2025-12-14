import "dart:convert";
import "package:http/http.dart" as http;
import "../app_config.dart";
import "../models/book.dart";

class BookService {
  Future<List<Book>> searchByCategory(String category) async {
    final q = Uri.encodeQueryComponent(category);
    final url =
        "${AppConfig.googleBooksBase}?q=$q+philosophy&maxResults=10&key=${AppConfig.googleApiKey}";

    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) return [];

    final jsonMap = json.decode(res.body) as Map<String, dynamic>;
    final items = (jsonMap["items"] as List<dynamic>?) ?? [];

    return items.map((it) {
      final m = it as Map<String, dynamic>;
      final id = (m["id"] ?? "").toString();
      final volume = (m["volumeInfo"] as Map<String, dynamic>?) ?? {};
      final title = (volume["title"] ?? "Untitled").toString();
      final authorsList = (volume["authors"] as List<dynamic>?)?.map((e) => e.toString()).toList();
      final authors = (authorsList == null || authorsList.isEmpty) ? "Unknown" : authorsList.join(", ");
      final imageLinks = (volume["imageLinks"] as Map<String, dynamic>?) ?? {};
      final thumb = imageLinks["thumbnail"]?.toString();

      return Book(id: id, title: title, authors: authors, thumbnail: thumb);
    }).toList();
  }
}
