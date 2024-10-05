import 'dart:convert';
import 'package:flutter/services.dart';

class Question {
  final String id;
  final String questionText;
  final List<Option> options;

  Question(
      {required this.id, required this.questionText, required this.options});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      questionText: json['question'],
      options: (json['options'] as List)
          .map((option) => Option.fromJson(option))
          .toList(),
    );
  }
}

class Option {
  final String text;
  final int score;
  final String next;

  Option({required this.text, required this.score, required this.next});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      text: json['text'],
      score: json['score'],
      next: json['next'],
    );
  }
}

Future<List<Question>> loadQuestions() async {
  String jsonString = await rootBundle.loadString('assets/questionnaire.json');
  List<dynamic> jsonData = json.decode(jsonString);
  return jsonData.map((json) => Question.fromJson(json)).toList();
}