import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class FinancialAdviceScreen extends StatefulWidget {
  @override
  _FinancialAdviceScreenState createState() => _FinancialAdviceScreenState();
}

class _FinancialAdviceScreenState extends State<FinancialAdviceScreen> {
  // Chatbot variables
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  int _questionIndex = 0;
  double _totalExpenses = 0;

  final List<Map<String, dynamic>> _questions = [
    {
      "question": "What is your current monthly rent or mortgage payment?",
      "key": "Rent"
    },
    {
      "question": "How much is your monthly loan payment?",
      "key": "LoanPayment"
    },
    {"question": "What is your loan interest rate?", "key": "InterestRate"},
    {
      "question":
          "How do you commute? What are your monthly transportation costs?",
      "key": "Transportation"
    },
    {
      "question":
          "How much do you typically spend on electricity, water, gas, and internet each month?",
      "key": "Utilities"
    },
    {
      "question": "How much do you spend on groceries and dining out?",
      "key": "Food"
    },
    {
      "question":
          "What are your monthly expenses for entertainment, such as movies, concerts, and hobbies?",
      "key": "Entertainment"
    },
    {
      "question":
          "How much do you spend on personal care items like toiletries and clothing?",
      "key": "Personal Care"
    },
    {
      "question":
"How many other debts, besides the mentioned loan, are you currently paying off?",
      "key": "Debt Payments"
    },
    {
      "question":
          "How much do you spend on health insurance and medical expenses each month?",
      "key": "HealthExpenses"
    },
    {
      "question": "What are your monthly savings or investment contributions?",
      "key": "Savings"
    },
    
    {
      "question":
          "How much do you spend on clothing and personal items each month?",
      "key": "Clothing"
    },
    {
      "question":
          "What are your monthly expenses for household items (cleaning supplies, etc.)?",
      "key": "HouseholdItems"
    },
  ];

  Map<String, double> _userExpenses = {};

  @override
  void initState() {
    super.initState();
    _addBotMessage(
        "👋 Welcome! Let's calculate your monthly expenses and suggest ways to pay off your loan efficiently.");
    _addBotMessage(_questions[_questionIndex]["question"]!);
  }

  void _handleUserInput(String input) {
    if (_questionIndex < _questions.length) {
      final expenseKey = _questions[_questionIndex]['key'];
      double? parsedValue = double.tryParse(input);

      if (parsedValue != null) {
        _userExpenses[expenseKey] = parsedValue;

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
    _generatePDFReport();
  }

String _createSuggestions() {
  List<String> suggestions = [];

  // Rent Analysis
  double userRent = _userExpenses['Rent'] ?? 0;
  if (userRent > 10000) {
    suggestions.add(
        "You're spending a lot on rent. Consider downsizing or relocating to a more affordable area to free up funds for loan payments or savings.");
  } else if (userRent > 0) {
    suggestions.add("Your rent is within an acceptable range. Consider negotiating your lease for potential savings.");
  } else {
    suggestions.add("It looks like you don't have any rent payments. If you're a homeowner, ensure you're factoring in property-related costs.");
  }

  // Loan Payment Analysis
  double userLoanPayment = _userExpenses['LoanPayment'] ?? 0;
  double loanInterestRate = _userExpenses['InterestRate'] ?? 0;

  if (userLoanPayment > 0 && loanInterestRate > 0) {
    suggestions.add(
        "You're making progress on your loan. Keep paying consistently to reduce the principal and interest over time. Consider refinancing if interest rates drop.");
  } else {
    suggestions.add("Please ensure you've provided all loan-related information for a more accurate analysis.");
  }

  // Emergency Savings Analysis
  double userSavings = _userExpenses['Savings'] ?? 0;
  if (userSavings < 5000) {
    suggestions.add(
        "Your emergency savings appear low. Aim to build an emergency fund covering at least 3-6 months of living expenses.");
  } else {
    suggestions.add("Your savings look healthy. Keep building your emergency fund for added financial security.");
  }

  // Investment Contributions Analysis
  double userInvestments = _userExpenses['Investments'] ?? 0;
  if (userInvestments < 1000) {
    suggestions.add(
        "You're contributing a small amount to investments. Consider increasing your contributions to grow your wealth over time.");
  } else {
    suggestions.add(" Your investment contributions are on track. Ensure you're diversified to minimize risk.");
  }

  // Discretionary Spending Analysis
  double userDiscretionary = _userExpenses['DiscretionarySpending'] ?? 0;
  if (userDiscretionary > 5000) {
    suggestions.add(
        "Your discretionary spending seems high. Review your non-essential expenses and find areas to cut back.");
  } else {
    suggestions.add(
        "our discretionary spending is within a reasonable limit. Keep an eye on luxury purchases to avoid overspending.");
  }

  // Debt-to-Income Ratio Analysis
  double userIncome = _userExpenses['Income'] ?? 0;
  if (userIncome > 0) {
    double debtToIncomeRatio = (userLoanPayment / userIncome) * 100;
    if (debtToIncomeRatio > 40) {
      suggestions.add(
          "Your debt-to-income ratio is above 40%, which may be a risk for future loans. Consider reducing debt or increasing income.");
    } else {
      suggestions.add(
          "✔️ Your debt-to-income ratio is in a healthy range, allowing you more financial flexibility.");
    }
  } else {
    suggestions.add("Please provide your income for a more accurate debt-to-income analysis.");
  }

  return suggestions.join('\n');
}


  Future<void> _generatePDFReport() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text('Financial Report'),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Monthly Expenses Breakdown:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              ..._userExpenses.entries.map((entry) {
                return pw.Text(
                    '${entry.key}: Rs. ${entry.value.toStringAsFixed(2)}');
              }).toList(),
              pw.SizedBox(height: 20),
              pw.Text(
                  'Total Monthly Expenses: Rs. ${_totalExpenses.toStringAsFixed(2)}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Personalized Suggestions:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text(_createSuggestions()),
            ],
          );
        },
      ),
    );

    // Save or share the PDF
    await Printing.sharePdf(
        bytes: await pdf.save(), filename: 'financial_report.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Financial Advisor"),
        backgroundColor: Color.fromARGB(255, 81, 58, 183),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/portfolio');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: _generatePDFReport,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Align(
                    alignment: _messages[index]["role"] == "user"
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _messages[index]["role"] == "user"
                            ? Colors.blue
                            : Colors.grey[700],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _messages[index]["message"]!,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
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
                      hintText: "Type your answer...",
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: _handleUserInput,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _handleUserInput(_controller.text);
                    }
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
