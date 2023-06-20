import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_screen.dart';
import 'registration_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // late String selectedRole;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Get.to(const LoginScreen());
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(const RegistrationScreen());
              },
              child: const Text('Registration'),
            ),
          ],
        ),
      ),
    );
  }
}
