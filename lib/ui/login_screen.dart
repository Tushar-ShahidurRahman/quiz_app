import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/ui/registration_screen.dart';

import '../data/service/auth_service.dart';
import 'dashboard_screen.dart';
import '../data/custom_function/get_user_role_from_database.dart';

class LoginScreen extends StatefulWidget {
  final String? role;

  const LoginScreen({super.key, this.role});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<String?> _getUserRoleFromDatabase(String userId) async {
    try {
      // Get the user document from Firestore using the user ID
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        // Retrieve the user's role from the document data
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String role = data['role'];
        return role;
      } else {
        // User document does not exist
        return null;
      }
    } catch (error) {
      print('Error getting user role: $error');
      return null;
    }
  }

  // updated login method
  Future<void> _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    UserCredential? result =
        await _authService.signInWithEmailAndPassword(email, password);

    if (result != null) {
      // Get the user object from the result
      User user = result.user!;

      // Check the user's role and navigate accordingly
      // if (user) {
      // Get the user's role from the user document in the database
      String? role = await _getUserRoleFromDatabase(user.uid);
      // String role = widget.role!;

      if (role == 'teacher') {
        // Navigate to the teacher module
        Get.offAll(() => DashboardScreen(userRole: 'teacher'));
      } else if (role == 'student') {
        Get.offAll(() => DashboardScreen(userRole: 'student'));
      } else {
        // Invalid role, show an error message
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Login Error'),
              content: Text('Invalid role.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      }
      // }
    } else {
      // Show error message to the user
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Login Error'),
            content: Text('Invalid email or password.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _login,
                // onPressed: () {},
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 16.0),
          const Text('If not Registered', style: TextStyle(fontWeight: FontWeight.bold),),
          SizedBox(height: 8),
          FloatingActionButton.extended(
            onPressed: () {
              Get.off(() => RegistrationScreen());
            },
            label: Text('Registration'),
          ),
        ],
      ),
    );
  }
}
