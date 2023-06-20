import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:quiz_app/ui/dashboard_screen.dart';
import 'package:quiz_app/data/service/auth_service.dart';
import 'package:quiz_app/ui/login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  // final String role;

  const RegistrationScreen({
    super.key,
  });

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final AuthService _authService = AuthService();

  // FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 16.0),
            DropdownButton<String>(
              value: selectedRole,
              hint: const Text('Select Role'),
              onChanged: (value) {
                setState(() {
                  selectedRole = value;
                });
              },
              items: ['teacher', 'student'].map((role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              child: const Text('Register'),
              onPressed: () {
                // Handle register button press
                _registerUser();
              },
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 16.0),
          const Text(
            'Have an Account?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          FloatingActionButton.extended(
            onPressed: () {
              Get.off(() => LoginScreen());
            },
            label: Text('Login'),
          ),
        ],
      ),
    );
  }

  //this method is used to call register method and navigate to selected role.
  Future<void> _registerUser() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    UserCredential? result =
        await _authService.registerWithEmailAndPassword(email, password);

    if (result != null) {
      // Registration successful, add role to user document
      User user = result.user!;
      _authService.addUserToFirestore(selectedRole!, user, email, password);

      // Navigate to appropriate module based on role
      if (selectedRole == 'teacher') {
        Get.offAll(() => DashboardScreen(userRole: 'teacher'));
      } else if (selectedRole == 'student') {
        Get.offAll(() => DashboardScreen(userRole: 'student'));
        // There is actually no chance for user to enter any role other than these two.
      } else {
        // Invalid role, show an error message
        Get.defaultDialog(
          title: 'Registration Error',
          content: const Text('Invalid role.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      }
    } else {
      // Show error message to the user
      Get.defaultDialog(
        title: 'Registration Error',
        content: const Text('Invalid email or password.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      );
    }
  }
}
