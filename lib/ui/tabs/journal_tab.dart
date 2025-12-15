import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JournalTab extends StatefulWidget {
  const JournalTab({super.key});

  @override
  State<JournalTab> createState() => _JournalTabState();
}

class _JournalTabState extends State<JournalTab> {
  final ctrl = TextEditingController();

  // ---------- Linux/local journal ----------
  static const _localKey = "local_journal_entries";
  Future<List<String>> _loadLocal() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getStringList(_localKey) ?? <String>[];
  }

  Future<void> _addLocal(String text) async {
    final sp = await SharedPreferences.getInstance();
    final list = sp.getStringList(_localKey) ?? <String>[];
    list.insert(0, text);
    await sp.setStringList(_localKey, list);
  }

  // ---------- Firebase journal ----------
  CollectionReference<Map<String, dynamic>> _journalRef() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('journals');
  }

  Future<void> addEntry() async {
    final text = ctrl.text.trim();
    if (text.isEmpty) return;

    // Desktop: store locally
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      await _addLocal(text);
      ctrl.clear();
      setState(() {});
      return;
    }

    // Mobile: store in Firestore
    await _journalRef().add({
      "text": text,
      "createdAt": FieldValue.serverTimestamp(),
    });

    ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Desktop: local journal UI
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      return Scaffold(
        appBar: AppBar(title: const Text("Journal")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: ctrl,
                      decoration: const InputDecoration(
                        hintText: "Write your reflection...",
                        border: OutlineInputBorder(),
                      ),
                      minLines: 1,
                      maxLines: 4,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(onPressed: addEntry, icon: const Icon(Icons.send)),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<String>>(
                future: _loadLocal(),
                builder: (context, snap) {
                  final items = snap.data ?? [];
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (items.isEmpty) {
                    return const Center(child: Text("No entries yet."));
                  }
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, i) => ListTile(
                      leading: const Icon(Icons.edit_note),
                      title: Text(items[i]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    // ✅ Mobile: Firebase journal UI
    final q = _journalRef().orderBy("createdAt", descending: true).limit(30);

    return Scaffold(
      appBar: AppBar(title: const Text("Journal")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: ctrl,
                    decoration: const InputDecoration(
                      hintText: "Write your reflection...",
                      border: OutlineInputBorder(),
                    ),
                    minLines: 1,
                    maxLines: 4,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(onPressed: addEntry, icon: const Icon(Icons.send)),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: q.snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snap.data!.docs;
                if (docs.isEmpty) {
                  return const Center(child: Text("No entries yet."));
                }
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    final d = docs[i].data();
                    return ListTile(
                      leading: const Icon(Icons.edit_note),
                      title: Text(d["text"] ?? ""),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
