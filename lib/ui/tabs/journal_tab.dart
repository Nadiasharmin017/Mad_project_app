import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JournalTab extends StatefulWidget {
  const JournalTab({super.key});
  @override
  State<JournalTab> createState() => _JournalTabState();
}

class _JournalTabState extends State<JournalTab> {
  final ctrl = TextEditingController();

  CollectionReference<Map<String, dynamic>> journalRef() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('journals');
  }

  Future<void> addEntry() async {
    final text = ctrl.text.trim();
    if (text.isEmpty) return;

    await journalRef().add({
      "text": text,
      "createdAt": FieldValue.serverTimestamp(),
      // sentiment/themes will be filled by Gemini step (optional)
    });

    ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final q = journalRef().orderBy("createdAt", descending: true).limit(30);

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
            child: StreamBuilder(
              stream: q.snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snap.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    final d = docs[i].data();
                    return ListTile(
                      title: Text(d["text"] ?? ""),
                      subtitle: Text((d["sentiment"] ?? "").toString()),
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
