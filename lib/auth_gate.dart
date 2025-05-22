import 'package:admin/pages/home_page.dart';
import 'package:admin/pages/login_page.dart';
import 'package:admin/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AuthGate extends StatefulWidget {
  final GenerativeModel model;

  const AuthGate({
    super.key,
    required this.model,
  });

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final AuthenticationService _auth = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _auth.getAuthenticationState(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              body: Center(
                  child: CircularProgressIndicator(
                color: Theme.of(context).scaffoldBackgroundColor,
              )));
        } else {
          if (snapshot.data != null) {
            return HomePage(model: widget.model);
          } else {
            return const LoginPage();
          }
        }
      },
    );
  }
}
