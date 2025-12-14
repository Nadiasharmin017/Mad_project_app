import 'dart:io';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';
import 'services/quote_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'core/theme.dart';
import 'screens/start_screen.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase ONLY on supported platforms
  if (Platform.isAndroid || Platform.isIOS) {
  await Firebase.initializeApp();
}


  await NotificationService.instance.init();

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
  debugShowCheckedModeBanner: false,
  title: 'Philosophy App',
  theme: appTheme(),
  home: StartScreen(),

);
  }
}
