import 'package:admin/models/validators.dart';
import 'package:admin/services/authentication.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthenticationService _auth = AuthenticationService();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  

  void onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      return;
    } else {
      try {
        _auth.signInWithEmailAndPassword(
          _emailTextController.text,
          _passwordTextController.text,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 300,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailTextController,
                        decoration: const InputDecoration(
                          label: Text("Email"),
                        ),
                        focusNode: _focusNode,
                        onEditingComplete: () {
                          _focusNode.nextFocus();
                        },
                        validator: emailValidator,
                      ),
                      TextFormField(
                        controller: _passwordTextController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          label: Text("Password"),
                        ),
                        onEditingComplete: onSubmit,
                        validator: requiredFieldValidator,
                      ),
                      ElevatedButton(
                        onPressed: onSubmit, 
                        child: const Text("Log in"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}