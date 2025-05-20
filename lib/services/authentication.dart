import "package:firebase_auth/firebase_auth.dart";

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in method
  void signInWithEmailAndPassword(
    String email, 
    String password
  ) => _auth.signInWithEmailAndPassword(
    email: email, 
    password: password
  );
  
  // Retrieve authentication state
  Stream<User?> getAuthenticationState() => _auth.authStateChanges();

  // Sign out method
  void signOut() => _auth.signOut();
}