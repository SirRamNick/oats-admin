import 'package:admin/components/admin_color_theme.dart';
import 'package:admin/firebase_options.dart';
import 'package:admin/auth_gate.dart';
import 'package:admin/pages/analytics_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await dotenv.load(fileName: ".env");
  final GenerativeModel model = GenerativeModel(
      model: 'gemini-2.5-flash-preview-04-17',
      apiKey: "AIzaSyDZ6LW6p7LYveYRB6C6cKSsT0dG0-CKn6Q");
  runApp(MyApp(
    model: model,
  ));
}

class MyApp extends StatelessWidget {
  final GenerativeModel? model;
  const MyApp({
    super.key,
    this.model,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: adminTheme,
      title: "OATS | Admin Site",
      debugShowCheckedModeBanner: false,
      home: AuthGate(model: model!),
    );
  }
}
