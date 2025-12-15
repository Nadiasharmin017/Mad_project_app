import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFF121212),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
    ),

    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      indicatorColor: Colors.deepPurple,
      labelTextStyle: MaterialStatePropertyAll(
        TextStyle(color: Colors.white),
      ),
      iconTheme: MaterialStatePropertyAll(
        IconThemeData(color: Colors.white),
      ),
    ),
  );
}
