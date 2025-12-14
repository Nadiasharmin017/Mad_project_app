import "dart:convert";
import "package:flutter/services.dart";
import "package:http/http.dart" as http;
import "package:intl/intl.dart";
import "package:shared_preferences/shared_preferences.dart";
import "../app_config.dart";
import "../models/location_item.dart";

class LocationDetails {
  final LocationItem base;
  final String description;
  final String? thumbnail;
  final double? lat;
  final double? lng;
  final String? address;

  LocationDetails({
    required this.base,
    required this.description,
    this.thumbnail,
    this.lat,
    this.lng,
    this.address,
  });
}

class LocationService {
  static const _prefKeyDate = "loc_date";
  static const _prefKeyId = "loc_id";

  String _todayKey() => DateFormat("yyyy-MM-dd").format(DateTime.now());

  Future<LocationDetails> getTodayLocation() async {
    final locations = await _loadLocations();
    final prefs = await SharedPreferences.getInstance();
    final today = _todayKey();

    LocationItem chosen;
    if (prefs.getString(_prefKeyDate) == today) {
      final savedId = prefs.getString(_prefKeyId);
      chosen = locations.firstWhere((l) => l.id == savedId, orElse: () => locations.first);
    } else {
      final idx = DateTime.now().day % locations.length;
      chosen = locations[idx];
      await prefs.setString(_prefKeyDate, today);
      await prefs.setString(_prefKeyId, chosen.id);
    }

    final wiki = await _fetchWikiSummary(chosen.wikiTitle);
    final places = await _fetchPlaces(chosen.placeQuery);

    return LocationDetails(
      base: chosen,
      description: wiki.$1,
      thumbnail: wiki.$2,
      lat: places.$1,
      lng: places.$2,
      address: places.$3,
    );
  }

  String staticMapUrl({required double lat, required double lng}) {
    final center = "$lat,$lng";
    final markers = Uri.encodeQueryComponent("color:red|$center");
    return "${AppConfig.staticMapsBase}?center=$center&zoom=14&size=600x300&markers=$markers&key=${AppConfig.googleApiKey}";
  }

  Future<List<LocationItem>> _loadLocations() async {
    final raw = await rootBundle.loadString("assets/locations.json");
    final list = (json.decode(raw) as List<dynamic>).cast<Map<String, dynamic>>();
    return list.map(LocationItem.fromJson).toList();
  }

  Future<(String, String?)> _fetchWikiSummary(String title) async {
    try {
      final encoded = Uri.encodeComponent(title);
      final url = "${AppConfig.wikiSummaryBase}$encoded";
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200) return ("No description available.", null);
      final m = json.decode(res.body) as Map<String, dynamic>;
      final extract = (m["extract"] ?? "No description available.").toString();
      final thumb = (m["thumbnail"] as Map<String, dynamic>?)?["source"]?.toString();
      return (extract, thumb);
    } catch (_) {
      return ("No description available.", null);
    }
  }

  Future<(double?, double?, String?)> _fetchPlaces(String query) async {
    try {
      final q = Uri.encodeQueryComponent(query);
      final url = "${AppConfig.placesTextSearchBase}?query=$q&key=${AppConfig.googleApiKey}";
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200) return (null, null, null);

      final m = json.decode(res.body) as Map<String, dynamic>;
      final results = (m["results"] as List<dynamic>?) ?? [];
      if (results.isEmpty) return (null, null, null);

      final first = results.first as Map<String, dynamic>;
      final geom = (first["geometry"] as Map<String, dynamic>?) ?? {};
      final loc = (geom["location"] as Map<String, dynamic>?) ?? {};
      final lat = (loc["lat"] as num?)?.toDouble();
      final lng = (loc["lng"] as num?)?.toDouble();
      final address = first["formatted_address"]?.toString();
      return (lat, lng, address);
    } catch (_) {
      return (null, null, null);
    }
  }
}
