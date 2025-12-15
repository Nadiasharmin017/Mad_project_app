import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../services/location_service.dart';

class LocationsTab extends StatelessWidget {
  const LocationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final service = LocationService();

    return Scaffold(
      appBar: AppBar(title: const Text("Philosophical Places")),
      body: FutureBuilder(
        future: service.getTodayLocation(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final loc = snap.data!;
          final mapUrl = (loc.lat != null && loc.lng != null)
              ? service.staticMapUrl(lat: loc.lat!, lng: loc.lng!)
              : null;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                loc.base.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),

              // Wikipedia image
              if (loc.thumbnail != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: loc.thumbnail!,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),

              const SizedBox(height: 12),
              Text(
                loc.description,
                style: const TextStyle(height: 1.5),
              ),

              const SizedBox(height: 16),

              // 📍 MAP IMAGE (IMPORTANT PART)
              if (mapUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: mapUrl,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
