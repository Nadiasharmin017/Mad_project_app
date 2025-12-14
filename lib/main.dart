import 'dart:io';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';
import 'services/quote_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.instance.init();

  // 🔴 Schedule notifications ONLY on Android / iOS
  if (Platform.isAndroid || Platform.isIOS) {
    final q = await QuoteService().getTodayQuote();
    await NotificationService.instance.scheduleDailyAt(
      hour: 9,
      minute: 0,
      title: "Daily Philosophy",
      body: "“${q.text}” — ${q.author}",
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Philosophy App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const HomeScreen(),
    );
  }
}
