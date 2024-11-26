import 'package:flutter/material.dart';

ThemeData adminTheme = ThemeData(
  useMaterial3: true,
  primaryColor: const Color(0xFF0B085F),
  scaffoldBackgroundColor: const Color(0xFFFFD22F),
  primaryTextTheme: const TextTheme(
    bodySmall: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white),
  ),
  colorScheme: ColorScheme.fromSwatch(
    backgroundColor: const Color(0xFFFFD22F),
    // backgroundColor: const Color(0xFFE2E2E2),
  ),
  textTheme: const TextTheme(
    bodySmall: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    bodyLarge: TextStyle(color: Colors.black),
  ),
  appBarTheme: const AppBarTheme(
    // backgroundColor: Color(0xFFE2E2E2),
    // foregroundColor: Colors.black,
    backgroundColor: Color(0xFF0B085F),
    foregroundColor: Colors.white,
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xFFFFD22F),
  ),
  dividerTheme: const DividerThemeData(
    color: Colors.black,
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: Color(0xFFE2E2E2),
    titleTextStyle: TextStyle(color: Colors.black),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.black,
    ),
  ),
);