import 'dart:convert';

import 'factors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'question_model.dart'; // Import models

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  List<dynamic> _questions = [];
  int _currentQuestionIndex = 0;
  int _totalScore = 0;
  bool _isQuizCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadQuestionnaire();
  }

  Future<void> _loadQuestionnaire() async {
    final jsonString = await rootBundle.loadString('assets/questionnaire.json');
    final jsonData = json.decode(jsonString);
    setState(() {
      _questions = jsonData;
    });
  }

  void _answerQuestion(int score, String? nextQuestionId) {
    setState(() {
      _totalScore += score;

      // Check if nextQuestionId is null or empty, marking the quiz as completed
      if (nextQuestionId == null || nextQuestionId.isEmpty) {
        _isQuizCompleted = true;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                FactorsForm(totalScore: _totalScore), // Pass the score here
          ),
        );
      } else {
        int nextIndex = _questions.indexWhere((q) => q['id'] == nextQuestionId);

        if (nextIndex == -1) {
          _isQuizCompleted = true;
        } else {
          _currentQuestionIndex = nextIndex;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Questionnaire'),
          backgroundColor: const Color.fromARGB(255, 221, 219, 225),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];
    final questionText = currentQuestion['question'];
    final options = currentQuestion['options'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Behavioral Financial Analysis'),
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 22, 3, 117),
      ),
          body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  questionText,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 30),
                ...options.map<Widget>((option) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Color.fromARGB(255, 239, 239, 241),
                        backgroundColor: Color.fromARGB(255, 22, 3, 117),
                        padding: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () =>
                          _answerQuestion(option['score'], option['next']),
                      child: Text(
                        option['text'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                SizedBox(height: 30),
                // Center(
                //   child: Container(
                //     padding: EdgeInsets.all(12),
                //     decoration: BoxDecoration(
                //       gradient: LinearGradient(
                //         colors: [Colors.purple, Colors.deepPurple],
                //         begin: Alignment.topLeft,
                //         end: Alignment.bottomRight,
                //       ),
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //     child: Text(
                //       'Total Score: $_totalScore',
                //       style: TextStyle(
                //         fontSize: 20,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
        ),
      ),
     ),
    );
  }
}