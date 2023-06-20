import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/ui/student_dashboard_screen.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz;

  QuizScreen({
    required this.quiz
  });

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<int?> selectedAnswers = [];
  Map<int, int?> selectedOptions = {};


  @override
  void initState() {
    super.initState();
    // Initialize selectedAnswers and selectedOptions
    selectedAnswers = List<int?>.filled(widget.quiz.questions.length, null);
    selectedOptions = Map<int, int?>.from(selectedAnswers.asMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
      ),
      body: ListView.builder(
        itemCount: widget.quiz.questions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question ${index + 1}: ${widget.quiz.questions[index].question}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Column(
                  children:
                  List.generate(widget.quiz.questions[index].options.length,
                          (optionIndex) {
                        return RadioListTile<int>(
                          title: Text(
                              widget.quiz.questions[index].options[optionIndex]),
                          value: optionIndex,
                          groupValue: selectedAnswers.length > index
                              ? selectedAnswers[index]
                              : null,
                          onChanged: (value) {
                            setState(() {
                              selectedAnswers[index] = value!;
                              selectedOptions[index] = value;
                            });
                          },
                          activeColor: selectedOptions[index] == optionIndex
                              ? Colors.blue
                              : null,
                        );
                      }),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          List<int> selectedAnswers = widget.quiz.questions
              .asMap()
              .map((index, _) => MapEntry(index, selectedOptions[index] ?? -1))
              .values
              .toList();

          Get.showSnackbar(GetSnackBar(
            title: 'Score',
            message: selectedAnswers.toString(),
            duration: Duration(seconds: 3),
          ));
        },
        label: Text('Submit'),
      ),
    );
  }
}