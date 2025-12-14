import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    if (!Platform.isLinux) {
      await FirebaseAuth.instance.signOut();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logged out")),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🔒 Linux-safe fallback
    if (Platform.isLinux) {
      return Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          backgroundColor: const Color(0xFF121212),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "PROFILE",
            style: TextStyle(
              color: Color(0xFFC9A36A),
              letterSpacing: 1.2,
            ),
          ),
        ),
        body: _linuxProfile(context),
      );
    }

    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "PROFILE",
          style: TextStyle(
            color: Color(0xFFC9A36A),
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: _profileBody(context, user),
    );
  }

  // ================= UI SECTIONS =================

  Widget _profileBody(BuildContext context, User? user) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _infoCard(
            title: "Account",
            content: user?.email ?? "Unknown user",
          ),
          const SizedBox(height: 20),
          _logoutCard(context),
        ],
      ),
    );
  }

  Widget _linuxProfile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _infoCard(
            title: "Platform",
            content: "Profile works fully on Android / Web",
          ),
          const SizedBox(height: 20),
          _logoutCard(context),
        ],
      ),
    );
  }

  Widget _infoCard({required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFC9A36A).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFFC9A36A),
              fontSize: 13,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _logoutCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.redAccent.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "LOGOUT",
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 13,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () => _logout(context),
              child: const Text("SIGN OUT"),
            ),
          ),
        ],
      ),
    );
  }
}
