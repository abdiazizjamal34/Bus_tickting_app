import 'package:firebase_auth/firebase_auth.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up a new user
  Future<String> signupUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Optionally, update the user's display name
      await userCredential.user?.updateProfile(displayName: name);

      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An error occurred.";
    }
  }

  // Log in an existing user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An error occurred.";
    }
  }

  // Log out the current user
  Future<void> logoutUser() async {
    await _auth.signOut();
  }

  // Get the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
  // Get the current user's display name
  String getCurrentUserName() {
    User? user = _auth.currentUser;
    return user?.displayName ?? "User"; // Default to "User" if no name is set
  }
}