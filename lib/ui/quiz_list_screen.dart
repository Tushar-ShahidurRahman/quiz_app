import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/ui/student_dashboard_screen.dart';

import 'quiz_screen.dart';

class QuizListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Quizzes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('quizzes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
      // Saving all quizz in the quizzes list.
            final List<Quiz> quizzes = snapshot.data!.docs.map((quizDoc) {

      // Getting hold of a single quiz data
              final quizData = quizDoc.data() as Map<String, dynamic>;

      // Getting all the questions of a quiz in a list called questionData
              final List<Map<String, dynamic>> questionsData =
              List.from(quizData['questions']);

              final List<Question> questions =
              questionsData.map((questionData) {
                final List<String> options =
                List<String>.from(questionData['options']);
                return Question(
                    question: questionData['question'], options: options);
              }).toList();

              return Quiz(
                  id: quizDoc.id, title: quizData['title'], questions: questions);
            }).toList();

            return ListView.builder(
              itemCount: quizzes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    tileColor: Colors.grey,
                    title: Text(quizzes[index].title),
                    onTap: () {
                      Get.to(() => QuizScreen(quiz: quizzes[index]));

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => QuizScreen(quiz: quizzes[index]),
                      //   ),
                      // );
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}


//Note for my self

// body: StreamBuilder<QuerySnapshot>(
//     stream: FirebaseFirestore.instance.collection('quizzes').snapshots(),
//     builder: (context, snapshot) {
//       if(snapshot.hasData) {
//         List<Quiz> quizzes = snapshot.data!.docs.map((quizDoc) {
//           final quiz = quizDoc.data() as Map<String, dynamic>;
//              final List<Question> quizQuestions = List.from(quiz['quistions']);
//               final individualQuestion = quizQuestions.map((question) {
//                 final options = question.options;
//                 // question = question['question'];
//                 return Question(question: question, options: options);
//               }).toList();
//
//               return Quiz(id: quiz.id, title: quiz.title, questions: quizQuestions);
//         } ).toList();
//       }
//     },) ,