import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding
import 'package:firebase_auth/firebase_auth.dart'; // For Firebase Authentication
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore

class PredictionForm extends StatefulWidget {
  @override
  _PredictionFormState createState() => _PredictionFormState();
}

class _PredictionFormState extends State<PredictionForm> {
  final _formKey = GlobalKey<FormState>();

  // TextEditingController to capture form input
  final TextEditingController ageController = TextEditingController();
  final TextEditingController annualIncomeController = TextEditingController();
  final TextEditingController creditScoreController = TextEditingController();
  final TextEditingController employmentStatusController =
      TextEditingController();
  final TextEditingController loanAmountController = TextEditingController();
  final TextEditingController loanDurationController = TextEditingController();
  final TextEditingController maritalStatusController = TextEditingController();
  final TextEditingController numberOfDependentsController =
      TextEditingController();
  final TextEditingController homeOwnershipStatusController =
      TextEditingController();
  final TextEditingController bankruptcyHistoryController =
      TextEditingController();
  final TextEditingController paymentHistoryController =
      TextEditingController();
  final TextEditingController totalAssetsController = TextEditingController();
  final TextEditingController totalLiabilitiesController =
      TextEditingController();
  final TextEditingController monthlyIncomeController = TextEditingController();
  final TextEditingController netWorthController = TextEditingController();
  final TextEditingController monthlyLoanPaymentController =
      TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when no longer used
    ageController.dispose();
    annualIncomeController.dispose();
    creditScoreController.dispose();
    employmentStatusController.dispose();
    loanAmountController.dispose();
    loanDurationController.dispose();
    maritalStatusController.dispose();
    numberOfDependentsController.dispose();
    homeOwnershipStatusController.dispose();
    bankruptcyHistoryController.dispose();
    paymentHistoryController.dispose();
    totalAssetsController.dispose();
    totalLiabilitiesController.dispose();
    monthlyIncomeController.dispose();
    netWorthController.dispose();
    monthlyLoanPaymentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loan Prediction',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 22, 3, 117),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/portfolio');
          },
        ),
      ),
      backgroundColor: Colors.white, // Set background to white
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField('Age', ageController, isNumeric: true),
              buildTextField('Annual Income', annualIncomeController,
                  isNumeric: true),
              buildTextField('Credit Score', creditScoreController,
                  isNumeric: true),
              buildTextField('Employment Status', employmentStatusController),
              buildTextField('Loan Amount', loanAmountController,
                  isNumeric: true),
              buildTextField('Loan Duration', loanDurationController,
                  isNumeric: true),
              buildTextField('Marital Status', maritalStatusController),
              buildTextField(
                  'Number of Dependents', numberOfDependentsController,
                  isNumeric: true),
              buildTextField(
                  'Home Ownership Status', homeOwnershipStatusController),
              buildTextField('Bankruptcy History', bankruptcyHistoryController),
              buildTextField('Payment History', paymentHistoryController),
              buildTextField('Total Assets', totalAssetsController,
                  isNumeric: true),
              buildTextField('Total Liabilities', totalLiabilitiesController,
                  isNumeric: true),
              buildTextField('Monthly Income', monthlyIncomeController,
                  isNumeric: true),
              buildTextField('Net Worth', netWorthController, isNumeric: true),
              buildTextField(
                  'Monthly Loan Payment', monthlyLoanPaymentController,
                  isNumeric: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Call function to send data to Flask server
                    sendPredictionRequest(context);
                  }
                },
                child: Text('Predict'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 22, 3, 117), // Set button color
                  textStyle: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build text fields with TextEditingController
  Widget buildTextField(String label, TextEditingController controller,
      {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        style: TextStyle(color: Colors.black), // Text color black
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 22, 3, 117), // Border color
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color:
                  Color.fromARGB(255, 22, 3, 117), // Border color when focused
            ),
          ),
        ),
        cursorColor: Color.fromARGB(255, 22, 3, 117), // Cursor color
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (isNumeric && double.tryParse(value) == null) {
            return 'Please enter a valid number for $label';
          }
          return null;
        },
      ),
    );
  }

  // Function to send form data to the Flask server and store in Firebase
  void sendPredictionRequest(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      showErrorDialog(context, 'User not logged in');
      return;
    }

    final userId = user.uid; // Capture the user ID

    final data = {
      'Age': int.parse(ageController.text),
      'AnnualIncome': double.parse(annualIncomeController.text),
      'CreditScore': int.parse(creditScoreController.text),
      'EmploymentStatus': employmentStatusController.text,
      'LoanAmount': double.parse(loanAmountController.text),
      'LoanDuration': int.parse(loanDurationController.text),
      'MaritalStatus': maritalStatusController.text,
      'NumberOfDependents': int.parse(numberOfDependentsController.text),
      'HomeOwnershipStatus': homeOwnershipStatusController.text,
      'BankruptcyHistory': bankruptcyHistoryController.text,
      'PaymentHistory': paymentHistoryController.text,
      'TotalAssets': double.parse(totalAssetsController.text),
      'TotalLiabilities': double.parse(totalLiabilitiesController.text),
      'MonthlyIncome': double.parse(monthlyIncomeController.text),
      'NetWorth': double.parse(netWorthController.text),
      'MonthlyLoanPayment': double.parse(monthlyLoanPaymentController.text),
    };

    try {
      final response = await http.post(
        Uri.parse(
            'https://024e-2401-4900-5605-1af0-4cdd-d958-d4b8-4b0d.ngrok-free.app/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        if (result.containsKey('prediction')) {
          final prediction = result['prediction'][0];

          // Store input and prediction in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('predictions')
              .add({
            'input': data,
            'prediction': prediction,
            'userId': userId, // Include user ID in the document
            'timestamp': FieldValue.serverTimestamp(),
          });

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Prediction Result'),
              content: Text('The predicted result is: $prediction'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          showErrorDialog(context, 'Unexpected response format');
        }
      } else {
        showErrorDialog(context, 'Failed to get prediction from server');
      }
    } catch (e) {
      showErrorDialog(context, 'Error occurred: $e');
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
