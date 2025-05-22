import 'package:admin/models/validators.dart';
import 'package:admin/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthenticationService _auth = AuthenticationService();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? errorMessage;
  bool isLoading = false;

  void onSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        setState(() {
          isLoading = true;
        });
        await _auth.signInWithEmailAndPassword(
          _emailTextController.text,
          _passwordTextController.text,
        );
      } on FirebaseAuthException catch (e) {
        String errorString;
        switch (e.code) {
          case 'invalid-credential':
            errorString = "Invalid email or password";
            break;
          case 'user-disabled':
            errorString = "This user account has been disabled";
            break;
          default:
            errorString = e.message ?? "Something went wrong";
        }
        setState(() {
          errorMessage = errorString;
        });
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://lh3.googleusercontent.com/d/1MGemsbZGVRh9g_cJMi7fGDz51L9hTC4x',
            ),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
        ),
        child: Center(
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(12.0),
            child: IntrinsicHeight(
              child: Column(
                spacing: 8.0,
                children: [
                  SizedBox(
                    width: 740,
                    child: Image.network(
                        'https://lh3.googleusercontent.com/d/1tUIidRs4zuCSM8phHqcoVFOAWXOoYnd4'),
                  ),
                  errorMessage != null
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            errorMessage!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                      : const SizedBox.shrink(),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16.0,
                      ),
                      child: SizedBox(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            spacing: 12,
                            children: [
                              Text(
                                "Admin Log-in",
                                style: TextStyle(
                                  fontSize: TextTheme.of(context)
                                      .titleLarge!
                                      .fontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextFormField(
                                controller: _emailTextController,
                                enabled: !isLoading,
                                decoration: const InputDecoration(
                                  labelText: "Email Address",
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                ),
                                focusNode: _emailFocusNode,
                                onEditingComplete: () {
                                  if (_passwordTextController.text.isEmpty) {
                                    _passwordFocusNode.requestFocus();
                                  } else {
                                    _emailFocusNode.unfocus();
                                  }
                                },
                                validator: emailValidator,
                              ),
                              TextFormField(
                                controller: _passwordTextController,
                                enabled: !isLoading,
                                obscureText: true,
                                focusNode: _passwordFocusNode,
                                decoration: const InputDecoration(
                                  labelText: "Password",
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                ),
                                onEditingComplete: () {
                                  _passwordFocusNode.unfocus();
                                  onSubmit();
                                },
                                validator: requiredFieldValidator,
                              ),
                              ElevatedButton(
                                onPressed: isLoading ? null : onSubmit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  fixedSize: const Size.fromWidth(100.0),
                                ),
                                child: isLoading
                                    ? const SpinKitWave(
                                        color: Colors.white,
                                        size: 12.0,
                                      )
                                    : Text(
                                        "Log in",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }
}
