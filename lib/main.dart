import 'package:admin/components/admin_color_theme.dart';
import 'package:admin/firebase_options.dart';
import 'package:admin/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: adminTheme,
      title: "OATS Admin Site",
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
