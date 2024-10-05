import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FinancialAdviceScreen extends StatefulWidget {
  @override
  _FinancialAdviceScreenState createState() => _FinancialAdviceScreenState();
}

class _FinancialAdviceScreenState extends State<FinancialAdviceScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? _userData;
  bool _loading = true;

  // Chatbot variables
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  int _questionIndex = 0;
  double _totalExpenses = 0;

  final List<Map<String, dynamic>> _questions = [
    {"question": "What is your current monthly rent or mortgage payment?", "key": "Rent"},
    {"question": "How much is your monthly loan payment?", "key": "LoanPayment"},
    {"question": "What is your loan interest rate?", "key": "InterestRate"},
    {"question": "How do you commute? What are your monthly transportation costs?", "key": "Transportation"},
    {"question": "How much do you typically spend on electricity, water, gas, and internet each month?", "key": "Utilities"},
    {"question": "How much do you spend on groceries and dining out?", "key": "Food"},
    {"question": "What are your monthly expenses for entertainment, such as movies, concerts, and hobbies?", "key": "Entertainment"},
    {"question": "How much do you spend on personal care items like toiletries and clothing?", "key": "Personal Care"},
    {"question": "Are you paying off any other debts besides the loan mentioned?", "key": "Debt Payments"},
    {"question": "How much do you spend on health insurance and medical expenses each month?", "key": "HealthExpenses"},
    {"question": "What are your monthly savings or investment contributions?", "key": "Savings"},
    {"question": "Do you have any subscriptions or memberships (e.g., Netflix, gym)? What do they cost?", "key": "Subscriptions"},
    {"question": "How much do you spend on clothing and personal items each month?", "key": "Clothing"},
    {"question": "What are your monthly expenses for household items (cleaning supplies, etc.)?", "key": "HouseholdItems"},
  ];

  Map<String, double> _userExpenses = {};
  Map<String, double> _prediction = {};
  Map<String, double> _riskAnalysis = {};

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _addBotMessage("👋 Welcome! Let's calculate your monthly expenses and suggest ways to pay off your loan efficiently.");
    _addBotMessage(_questions[_questionIndex]["question"]!);
  }

Future<void> _fetchUserData() async {
  setState(() {
    _loading = true;
  });

  try {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      print("Current user ID: ${currentUser.uid}");
      
      // Fetch user document
      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(currentUser.uid).get();
      if (userSnapshot.exists) {
        print("User document exists");
        setState(() {
          _userData = userSnapshot.data() as Map<String, dynamic>?;
          print("User data: $_userData");
        });

        // Fetch prediction subcollection
        QuerySnapshot predictionSnapshot = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('predictions')
            .limit(1)  // Assuming you want the first prediction document
            .get();

        if (predictionSnapshot.docs.isNotEmpty) {
          print("Prediction document exists");
          Map<String, dynamic> predictionData = predictionSnapshot.docs.first.data() as Map<String, dynamic>;
          print("Prediction data: $predictionData");

          // Access the 'prediction' field within the document
          if (predictionData.containsKey('prediction')) {
            setState(() {
              _prediction = (predictionData['prediction'] as Map<String, dynamic>)
                  .map((key, value) => MapEntry(key, value.toDouble()));
              print("Risk analysis data: $_prediction");
            });
          } else {
            print("Prediction field not found in document");
          }
        } else {
          print("No prediction documents found for this user");
        }
      } else {
        print("User document does not exist for ID: ${currentUser.uid}");
      }
    } else {
      print("No user is currently signed in.");
    }
  } catch (e) {
    print("Error fetching data: $e");
  } finally {
    setState(() {
      _loading = false;
    });
  }
}

  void _handleUserInput(String input) async {
    if (_questionIndex < _questions.length) {
      final expenseKey = _questions[_questionIndex]['key'];
      double? parsedValue = double.tryParse(input);

      if (parsedValue != null) {
        _userExpenses[expenseKey] = parsedValue;

        try {
          User? currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser != null) {
            await _firestore.collection('users').doc(currentUser.uid).set({
              'expenses': {expenseKey: parsedValue},
            }, SetOptions(merge: true));
          }
        } catch (e) {
          print("Error saving response to Firestore: $e");
        }

        setState(() {
          _messages.add({
            "role": "user",
            "message": input,
          });

          if (_questionIndex < _questions.length - 1) {
            _questionIndex++;
            _addBotMessage(_questions[_questionIndex]["question"]!);
          } else {
            _calculateExpenses();
            _generatePersonalizedSuggestions();
          }
        });
      } else {
        _addBotMessage("Please enter a valid number.");
      }
    }
    _controller.clear();
  }

  void _addBotMessage(String message) {
    setState(() {
      _messages.add({
        "role": "bot",
        "message": message,
      });
    });
  }

  void _calculateExpenses() {
    _totalExpenses = _userExpenses.values.fold(0, (sum, value) => sum + value);
  }

  void _generatePersonalizedSuggestions() {
    String suggestions = _createSuggestions();
    _addBotMessage(
        "Based on your total monthly expenses of Rs. $_totalExpenses, here's some personalized advice on paying off your loan efficiently:\n\n$suggestions");
  }

  String _createSuggestions() {
    List<String> suggestions = [];

    double userRent = _userExpenses['Rent'] ?? 0;
    if (userRent > 10000) {
      suggestions.add("💡 You're spending a lot on rent. Consider downsizing to free up more funds for loan payments.");
    } else {
      suggestions.add("👍 Your rent is within an acceptable range.");
    }

    double userLoanPayment = _userExpenses['LoanPayment'] ?? 0;
    double loanInterestRate = _userExpenses['InterestRate'] ?? 0;
    double loanPrincipal = _userData?['LoanAmount'] ?? 0;

    if (userLoanPayment > 0 && loanInterestRate > 0 && loanPrincipal > 0) {
      double monthlyInterest = (loanPrincipal * (loanInterestRate / 100)) / 12;
      if (userLoanPayment > monthlyInterest) {
        suggestions.add("✅ You're making good progress on your loan. Keep paying more than the monthly interest to reduce the principal.");
      } else {
        suggestions.add("⚠️ Your loan payment is mostly covering interest. Try to pay more to reduce the principal and pay off your loan faster.");
      }
    } else {
      suggestions.add("Please ensure you've provided all loan-related information.");
    }

    return suggestions.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Financial Advisor"),
        backgroundColor: Color.fromARGB(255, 81, 58, 183),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      // Left side: Risk Analysis Score
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: _prediction.isNotEmpty
                                ? Center(
                                    child: Text(
                                      "Risk Score: ${_prediction.values.reduce((a, b) => a + b).toStringAsFixed(2)}",
                                      style: TextStyle(color: Colors.white, fontSize: 18),
                                    ),
                                  )
                                : Center(child: Text("No risk analysis data available", style: TextStyle(color: Colors.white))),
                          ),
                        ),
                      ),
                      
                      // Right side: User Features from Firebase
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: _userData != null
                                ? Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      "User Details:\nLoan Amount: Rs. ${_userData!['LoanAmount']}\nInterest Rate: ${_userData!['InterestRate']}%",
                                      style: TextStyle(color: Colors.white, fontSize: 18),
                                    ),
                                  )
                                : Center(child: Text("No user data available", style: TextStyle(color: Colors.white))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  flex: 3,
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return ListTile(
                        leading: message["role"] == "bot"
                            ? CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                child: Text("Bot"),
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.greenAccent,
                                child: Text("You"),
                              ),
                        title: Text(message["message"]!),
                      );
                    },
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            labelText: "Your answer",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          _handleUserInput(_controller.text);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
