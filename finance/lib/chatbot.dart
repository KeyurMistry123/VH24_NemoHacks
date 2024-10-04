import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import

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
    // New questions added
    {"question": "How much do you spend on health insurance and medical expenses each month?", "key": "HealthExpenses"},
    {"question": "What are your monthly savings or investment contributions?", "key": "Savings"},
    {"question": "Do you have any subscriptions or memberships (e.g., Netflix, gym)? What do they cost?", "key": "Subscriptions"},
    {"question": "How much do you spend on clothing and personal items each month?", "key": "Clothing"},
    {"question": "What are your monthly expenses for household items (cleaning supplies, etc.)?", "key": "HouseholdItems"},
  ];

  Map<String, double> _userExpenses = {};

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data from Firestore
    _addBotMessage("👋 Welcome! Let's calculate your monthly expenses and suggest ways to pay off your loan efficiently.");
    _addBotMessage(_questions[_questionIndex]["question"]!);
  }

  Future<void> _fetchUserData() async {
    try {
      // Fetching user-specific data from Firestore
      DocumentSnapshot snapshot = await _firestore.collection('users').doc('userId').get();
      setState(() {
        _userData = snapshot.data() as Map<String, dynamic>?; 
        _loading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  // Handle chatbot logic
  void _handleUserInput(String input) {
    if (_questionIndex < _questions.length) {
      final expenseKey = _questions[_questionIndex]['key'];
      _userExpenses[expenseKey] = double.tryParse(input) ?? 0;

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

  // Generate personalized savings and loan repayment suggestions based on user input + fetched loan data from Firestore
  String _createSuggestions() {
    List<String> suggestions = [];

    // Rent
    double userRent = _userExpenses['Rent'] ?? 0;
    if (userRent > 10000) {
      suggestions.add("💡 You're spending a lot on rent. Consider downsizing to free up more funds for loan payments.");
    } else {
      suggestions.add("👍 Your rent is within an acceptable range.");
    }

    // Loan Payment
    double userLoanPayment = _userExpenses['LoanPayment'] ?? 0;
    double loanInterestRate = _userExpenses['InterestRate'] ?? 0;
    double loanPrincipal = _userExpenses['LoanPrincipal'] ?? 0;

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

    // Transportation
    double userTransportation = _userExpenses['Transportation'] ?? 0;
    if (userTransportation > 2000) {
      suggestions.add("🚗 Consider using public transport or carpooling to save on transportation costs.");
    }

    // Utilities
    double userUtilities = _userExpenses['Utilities'] ?? 0;
    if (userUtilities > 3000) {
      suggestions.add("💡 Reducing utility usage can lead to significant savings. Consider energy-efficient appliances.");
    }

    // Food
    double userFood = _userExpenses['Food'] ?? 0;
    if (userFood > 5000) {
      suggestions.add("🍽️ Try meal planning and cooking at home to save on food expenses.");
    }

    // Entertainment
    double userEntertainment = _userExpenses['Entertainment'] ?? 0;
    if (userEntertainment > 2000) {
      suggestions.add("🎟️ Consider cutting back on non-essential entertainment to save money.");
    }

    // Personal Care
    double userPersonalCare = _userExpenses['Personal Care'] ?? 0;
    if (userPersonalCare > 1500) {
      suggestions.add("🛍️ Look for discounts on personal care items to save money.");
    }

    // Health Expenses
    double userHealthExpenses = _userExpenses['HealthExpenses'] ?? 0;
    if (userHealthExpenses > 3000) {
      suggestions.add("🏥 Consider reviewing your health insurance plan for better coverage and savings.");
    }

    // Savings
    double userSavings = _userExpenses['Savings'] ?? 0;
    if (userSavings < 1000) {
      suggestions.add("💰 Aim to save at least 10% of your income for emergencies and future investments.");
    }

    // Subscriptions
    double userSubscriptions = _userExpenses['Subscriptions'] ?? 0;
    if (userSubscriptions > 1000) {
      suggestions.add("📅 Review your subscriptions and consider canceling those you rarely use.");
    }

    // Clothing
    double userClothing = _userExpenses['Clothing'] ?? 0;
    if (userClothing > 2000) {
      suggestions.add("👗 Shop during sales or consider thrift stores to save on clothing expenses.");
    }

    // Household Items
    double userHouseholdItems = _userExpenses['HouseholdItems'] ?? 0;
    if (userHouseholdItems > 1000) {
      suggestions.add("🧼 Buy in bulk for household items to save on long-term expenses.");
    }

    return suggestions.join("\n\n");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF181818),
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text("Financial Advisor"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Firestore Data Section
          _loading
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              : _userData == null
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          "Failed to load user data 😔",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome back, ${_userData!['name']}!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Loan Amount: Rs. ${_userData!['loanAmount']}",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Monthly Payment: Rs. ${_userData!['monthlyPayment']}",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
          Divider(color: Colors.white),
          // Chatbot Section
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessageBubble(message['message']!, message['role']!);
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
                            labelText: 'Enter your answer...',
                            labelStyle: TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.white12,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                          onSubmitted: _handleUserInput,
                        ),
                      ),
                      SizedBox(width: 8),
                      FloatingActionButton(
                        backgroundColor: Colors.deepPurpleAccent,
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            _handleUserInput(_controller.text);
                          }
                        },
                        child: Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String message, String role) {
    bool isUser = role == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isUser ? Colors.deepPurpleAccent : Colors.grey[800],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}