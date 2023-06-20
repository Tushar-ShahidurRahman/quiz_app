import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/data/service/auth_service.dart';
import 'package:quiz_app/main.dart';
import 'package:quiz_app/ui/home_page.dart';
import 'package:quiz_app/ui/login_screen.dart';
import 'package:quiz_app/ui/student_dashboard_screen.dart';
import 'package:quiz_app/ui/teacher_dashboard_screen.dart';

class DashboardScreen extends StatelessWidget {
  final AuthService _authService = AuthService();
  final String userRole;

  DashboardScreen({required this.userRole});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [IconButton(onPressed: () {
          _authService.signOut();
          Get.off(() =>LoginScreen());
        },
            icon: Icon(Icons.logout))],
      ),
      body: Center(
        child: userRole == 'teacher'
            ? TeacherDashboardScreen()
            : StudentDashboardScreen(),
      ),
    );
  }
}
