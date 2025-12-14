class LocationItem {
  final String id;
  final String title;
  final String wikiTitle;
  final String placeQuery;

  LocationItem({
    required this.id,
    required this.title,
    required this.wikiTitle,
    required this.placeQuery,
  });

  static LocationItem fromJson(Map<String, dynamic> json) => LocationItem(
        id: json["id"],
        title: json["title"],
        wikiTitle: json["wikiTitle"],
        placeQuery: json["placeQuery"],
      );
}
