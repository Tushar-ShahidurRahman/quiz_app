import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// late User currentUser;

//
//   Register with email and password
  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential? result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // User currentUser = result.user!;
      return result;
    } catch (error) {
      log('Registration error: $error');
      return null;
      // throw Exception('Registration failed');
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } catch (error) {
      log('Login error: $error');
      return null;
      // throw Exception('Login failed: $error');
    }
  }

  addUserToFirestore(String role, User user, email, password) async {
    await _firestore.collection('users').doc(user.uid).set({
      'role': role,
      'email': email,
      'password': password,
    });
  }

// Future<UserCredential?> loginUser(String email, String password) async {
//   try {
//     UserCredential result = await _auth.signInWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//     User? user = result.user;
//     // Use the user object as needed
//     return result;
//   } catch (error) {
//     // Handle login error
//     log('Login error: $error');
//     return null;
//   }
// }

//
  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
