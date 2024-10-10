import 'package:finance/updated_stocks.dart';
import 'package:flutter/material.dart';
import 'analysisrisk.dart';
import 'updated_stocks.dart';

// Note: You need to create a PredictionForm widget in a separate file
// and import it here. For now, I'll comment out the import to avoid errors.
// import 'prediction_form.dart';

class FactorsForm extends StatefulWidget {
  final int totalScore;
  const FactorsForm({super.key, required this.totalScore});

  @override
  State<FactorsForm> createState() => _FactorsFormState();
}

class _FactorsFormState extends State<FactorsForm> {
  int ageScore = 0;
  int dependentsScore = 0;
  int incomeScore = 0;
  int occupationScore = 0;
  int financialGoalsScore = 0;
  int ailmentsScore = 0;
  int lifestyleScore = 0;
  int emergencyScore = 0;
  String riskProfile = "";

  late int totalScore = widget.totalScore;



void calculateTotalScore() {
    setState(() {
      // Calculate the total score
      totalScore = ageScore +
          dependentsScore +
          incomeScore +
          occupationScore +
          financialGoalsScore +
          ailmentsScore +
          lifestyleScore +
          emergencyScore +
          widget.totalScore;

      // Determine the risk profile based on the total score
      riskProfile = _determineRiskProfile();
    });

    // Show the SnackBar with the total score and risk profile
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Total Score: $totalScore\nRisk Profile: $riskProfile',
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.deepPurple.shade400,
        duration: const Duration(seconds: 2), // SnackBar will be shown for 2 seconds
      ),
    );

    // Navigate based on the risk profile
    Future.delayed(const Duration(seconds: 3), () {
      if (riskProfile == "Conservative (Low-risk Investor)") {
        Navigator.pushNamed(context, '/lowRisk');
      } else if (riskProfile == "Moderate (Medium-risk Investor)") {
        Navigator.pushNamed(context, '/mediumRisk');
      } else if (riskProfile == "Aggressive (High-risk Investor)") {
        Navigator.pushNamed(context, '/highRisk');
      } else {
        // If no valid profile, handle accordingly
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to determine risk profile.')),
        );
      }
    });
  }


  String _determineRiskProfile() {
    if (totalScore >= 18 && totalScore < 24) {
      return "Conservative (Low-risk Investor)";
    } else if (totalScore >= 24 && totalScore < 30) {
      return "Moderate (Medium-risk Investor)";
    } else if (totalScore >= 30 && totalScore <= 54) {
      return "Aggressive (High-risk Investor)";
    } else {
      return "Risk profile not determined.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Factors'),
        backgroundColor: Color.fromARGB(255, 22, 3, 117),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PredictionForm()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Age Dropdown
              _buildDropdown(
                label: 'Age',
                items: const [
                  DropdownMenuItem(child: Text("18-35"), value: 4),
                  DropdownMenuItem(child: Text("36-50"), value: 3),
                  DropdownMenuItem(child: Text("51-65"), value: 2),
                  DropdownMenuItem(child: Text("65+"), value: 1),
                ],
                onChanged: (value) {
                  setState(() {
                    ageScore = value!;
                  });
                },
              ),
              // Dependents Dropdown
              _buildDropdown(
                label: 'Dependents',
                items: const [
                  DropdownMenuItem(child: Text("0 dependents"), value: 3),
                  DropdownMenuItem(child: Text("1-2 dependents"), value: 2),
                  DropdownMenuItem(
                      child: Text("3 or more dependents"), value: 1),
                ],
                onChanged: (value) {
                  setState(() {
                    dependentsScore = value!;
                  });
                },
              ),
              // Income Dropdown
              _buildDropdown(
                label: 'Income (LPA)',
                items: const [
                  DropdownMenuItem(child: Text(">30 LPA"), value: 4),
                  DropdownMenuItem(child: Text("15-30 LPA"), value: 3),
                  DropdownMenuItem(child: Text("5-15 LPA"), value: 2),
                  DropdownMenuItem(child: Text("<5 LPA"), value: 1),
                ],
                onChanged: (value) {
                  setState(() {
                    incomeScore = value!;
                  });
                },
              ),
              // Occupation Dropdown
              _buildDropdown(
                label: 'Occupation',
                items: const [
                  DropdownMenuItem(child: Text("Stable job"), value: 2),
                  DropdownMenuItem(child: Text("Unstable job"), value: 1),
                ],
                onChanged: (value) {
                  setState(() {
                    occupationScore = value!;
                  });
                },
              ),
              // Financial Goals Dropdown
              _buildDropdown(
                label: 'Financial Goals',
                items: const [
                  DropdownMenuItem(
                      child: Text("Short-term, aggressive goals (1-3 years)"),
                      value: 3),
                  DropdownMenuItem(
                      child: Text("Medium-term goals (3-5 years)"), value: 2),
                  DropdownMenuItem(
                      child: Text("Long-term conservative goals(5+ years)"),
                      value: 1),
                ],
                onChanged: (value) {
                  setState(() {
                    financialGoalsScore = value!;
                  });
                },
              ),
              // Ailments Dropdown
              _buildDropdown(
                label: 'Ailments',
                items: const [
                  DropdownMenuItem(
                      child: Text("No medical conditions"), value: 3),
                  DropdownMenuItem(
                      child: Text("Major medical conditions"), value: 2),
                  DropdownMenuItem(child: Text("Fatal disease"), value: 1),
                ],
                onChanged: (value) {
                  setState(() {
                    ailmentsScore = value!;
                  });
                },
              ),
              // Lifestyle Dropdown
              _buildDropdown(
                label: 'Lifestyle',
                items: const [
                  DropdownMenuItem(
                      child: Text("Minimalist lifestyle"), value: 3),
                  DropdownMenuItem(
                      child: Text("Moderate/comfortable lifestyle"), value: 2),
                  DropdownMenuItem(child: Text("Luxury lifestyle"), value: 1),
                ],
                onChanged: (value) {
                  setState(() {
                    lifestyleScore = value!;
                  });
                },
              ),
              // Emergency Dropdown
              _buildDropdown(
                label: 'Emergency',
                items: const [
                  DropdownMenuItem(
                      child: Text("No sudden emergency"), value: 3),
                  DropdownMenuItem(
                      child: Text("Minor emergency (e.g. car repair)"),
                      value: 2),
                  DropdownMenuItem(
                      child: Text(
                          "Major emergency (e.g. surgery, fire, job loss)"),
                      value: 1),
                ],
                onChanged: (value) {
                  setState(() {
                    emergencyScore = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              // Calculate Button
              ElevatedButton(
                onPressed: calculateTotalScore,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 22, 3, 117),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Calculate Total Score",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              // Total Score Display
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color.fromARGB(255, 22, 3, 117)),
                ),
                child: Column(
                  children: [
                    Text(
                      "Total Score: $totalScore",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 22, 3, 117),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Your Risk Profile: $riskProfile",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 22, 3, 117),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build dropdowns
  Widget _buildDropdown({
    required String label,
    required List<DropdownMenuItem<int>> items,
    required ValueChanged<int?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<int>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Color.fromARGB(255, 22, 3, 117)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color.fromARGB(255, 22, 3, 117)),
          ),
        ),
        items: items,
        onChanged: onChanged,
        dropdownColor: Colors.white,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}