class Quote {
  final String text;
  final String author;
  final DateTime date; // day it belongs to

  Quote({required this.text, required this.author, required this.date});

  Map<String, dynamic> toMap() => {
        "text": text,
        "author": author,
        "date": date.toIso8601String(),
      };

  static Quote fromMap(Map<String, dynamic> map) => Quote(
        text: map["text"] as String,
        author: map["author"] as String,
        date: DateTime.parse(map["date"] as String),
      );
}
