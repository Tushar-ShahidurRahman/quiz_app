import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'quiz_list_screen.dart';
import 'quiz_screen.dart';

class Quiz {
  final String id;
  final String title;
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.title,
    required this.questions,
  });
}

class Question {
  final String question;
  final List<String> options;

  Question({
    required this.question,
    required this.options,
  });
}

class StudentDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Text(
          'Welcome, Student!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Center(
              child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => QuizListScreen());
                  },
                  child: const Text('See all the quizzes'))),
        ]),

        // Add student-specific UI components here
      ],
    );
  }
}




