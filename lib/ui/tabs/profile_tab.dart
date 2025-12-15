import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/notification_service.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool hourlyEnabled = true;

  Future<void> toggleNotifications(bool v) async {
    setState(() => hourlyEnabled = v);
    if (v) {
      await NotificationService.instance.enableHourlyNotifications();
    } else {
      await NotificationService.instance.cancelAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Profile & Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            user?.email ?? "",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 24),

          // 🔔 NOTIFICATION SECTION (VISIBLE)
          SwitchListTile(
            title: const Text("Hourly Notifications"),
            subtitle: const Text("Receive philosophy reminders every hour"),
            value: hourlyEnabled,
            onChanged: toggleNotifications,
          ),

          const Divider(height: 32),

          ElevatedButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
