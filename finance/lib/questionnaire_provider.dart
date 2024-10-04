import 'package:flutter/material.dart';

class QuestionnaireProvider with ChangeNotifier {
  double _riskTolerance = 3.0;
  String _investmentGoal = 'Growth';

  double get riskTolerance => _riskTolerance;
  String get investmentGoal => _investmentGoal;

  void setRiskTolerance(double value) {
    _riskTolerance = value;
    notifyListeners();
  }

  void setInvestmentGoal(String goal) {
    _investmentGoal = goal;
    notifyListeners();
  }

  void submitResponses() {
    // Code to save data to Firestore
  }
}
