import 'package:admin/pages/home_page.dart';
import 'package:admin/pages/login_page.dart';
import 'package:admin/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AuthGate extends StatelessWidget {
  final AuthenticationService _auth = AuthenticationService();
  final GenerativeModel model;
  
  AuthGate({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _auth.getAuthenticationState(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        else {
          if (snapshot.data != null) {
            return HomePage(model: model);
          }
          else {
            return const LoginPage();
          }
        }
      },
    );
  }
}