import 'package:admin/components/admin_color_theme.dart';
import 'package:admin/firebase_options.dart';
import 'package:admin/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  const String apiKey = 'AIzaSyDfhh7Ipr1c24IecqB3cofFXv9vmcpGelc';
  final GenerativeModel model =
      GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
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
      title: "OATS Admin Site",
      debugShowCheckedModeBanner: false,
      home: HomePage(
        model: model!,
      ),
    );
  }
}
