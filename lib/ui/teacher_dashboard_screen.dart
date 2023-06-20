import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../data/model_class/quiz_model_for_teacher.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  _TeacherDashboardScreenState createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  final List<QuizQuestion> _questions = [];
  final List<Quiz> _quizzes = [];

  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _option1Controller = TextEditingController();
  final TextEditingController _option2Controller = TextEditingController();
  final TextEditingController _option3Controller = TextEditingController();
  final TextEditingController _option4Controller = TextEditingController();
  final TextEditingController _correctAnswerController = TextEditingController();
  final TextEditingController _quizTitleController = TextEditingController();

  void _addQuestion() {
    String question = _questionController.text;
    String option1 = _option1Controller.text;
    String option2 = _option2Controller.text;
    String option3 = _option3Controller.text;
    String option4 = _option4Controller.text;
    int correctAnswerIndex = int.tryParse(_correctAnswerController.text) ?? 0;

    QuizQuestion quizQuestion = QuizQuestion(
      question: question,
      options: [option1, option2, option3, option4],
      correctAnswerIndex: correctAnswerIndex,
    );

    _questions.add(quizQuestion);
    print(_questions.length.toString());
    _questionController.clear();
    _option1Controller.clear();
    _option2Controller.clear();
    _option3Controller.clear();
    _option4Controller.clear();
    _correctAnswerController.clear();
  }

  void _saveQuiz() {
    if (_questions.isNotEmpty && _questions.length >= 2) {
      String quizTitle = _quizTitleController.text;
      Quiz quiz = Quiz(title: quizTitle, questions: List.from(_questions));
      _quizzes.add(quiz);
      print(_quizzes.length.toString());
      _questions.clear();
      _quizTitleController.clear();

      // Save the quiz to Firebase Firestore
      quizTitle.isEmpty
          ? Get.showSnackbar(
              const GetSnackBar(
                title: 'Quiz Title',
                message: 'Add quiz title',
              ),
            )
          : FirebaseFirestore.instance
              .collection('quizzes')
              .add(quiz.toMap())
              .then((value) => print('Quiz saved to Firestore: ${value.id}'))
              .catchError((error) => print('Failed to save quiz: $error'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Teacher Module',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Create Quiz',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            TextField(
              controller: _option1Controller,
              decoration: const InputDecoration(labelText: 'Option 1'),
            ),
            TextField(
              controller: _option2Controller,
              decoration: const InputDecoration(labelText: 'Option 2'),
            ),
            TextField(
              controller: _option3Controller,
              decoration: const InputDecoration(labelText: 'Option 3'),
            ),
            TextField(
              controller: _option4Controller,
              decoration: const InputDecoration(labelText: 'Option 4'),
            ),
            TextField(
              controller: _correctAnswerController,
              decoration:
                  const InputDecoration(labelText: 'Correct Answer Index'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _quizTitleController,
              decoration: const InputDecoration(labelText: 'Quiz title'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _addQuestion();
              },
              child: const Text('Add Question'),
            ),
            ElevatedButton(
              onPressed: () {
                _saveQuiz();
              },
              child: const Text('Save Quiz'),
            ),
            const SizedBox(height: 32),
            const Text(
              'Quizzes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _quizzes.isEmpty
                ? const Text(
                    'No Quiz Available',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _quizzes.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        tileColor: Colors.grey,
                        title: Text('Quiz ${index + 1}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.quiz),
                          onPressed: () {
                            _viewQuizResults(index);
                          },
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  void _viewQuizResults(int quizIndex) {
    Quiz quiz = _quizzes[quizIndex];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Quiz Results'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Quiz Title: Quiz ${quizIndex + 1}'),
              const SizedBox(height: 16),
              for (int i = 0; i < quiz.questions.length; i++)
                Text('Question ${i + 1}: ${quiz.questions[i].question}\n'
                    'Correct Answer Index: ${quiz.questions[i].correctAnswerIndex}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

