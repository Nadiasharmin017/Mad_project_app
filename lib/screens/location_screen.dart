import "package:flutter/material.dart";
import "package:cached_network_image/cached_network_image.dart";
import "../services/location_service.dart";

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final service = LocationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daily Location")),
      body: FutureBuilder(
        future: service.getTodayLocation(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final loc = snapshot.data!;

          final hasCoords = loc.lat != null && loc.lng != null;
          final mapUrl = hasCoords ? service.staticMapUrl(lat: loc.lat!, lng: loc.lng!) : null;

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Text(loc.base.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              if (loc.thumbnail != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(imageUrl: loc.thumbnail!, height: 180, fit: BoxFit.cover),
                ),
              const SizedBox(height: 10),
              Text(loc.description),
              const SizedBox(height: 12),
              if (loc.address != null)
                ListTile(
                  leading: const Icon(Icons.place),
                  title: Text(loc.address!),
                  subtitle: hasCoords ? Text("${loc.lat}, ${loc.lng}") : null,
                ),
              if (mapUrl != null) ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(imageUrl: mapUrl, height: 180, fit: BoxFit.cover),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
