import 'market_trend.dart';
import 'package:finance/analysisrisk.dart';
import 'package:finance/chatbot.dart';
import 'package:finance/questionnaire.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'news.dart';
import 'updated_stocks.dart';
import 'analysisrisk.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio Manager',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: PortfolioScreen(),
    );
  }
}

class PortfolioScreen extends StatefulWidget {
  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<PortfolioItem> portfolioItems = [
    PortfolioItem('Apple Inc.', 'AAPL', 50, 180.00, 150.00, 'Technology'),
    PortfolioItem('Tesla Inc.', 'TSLA', 25, 750.00, 800.00, 'Automotive'),
    PortfolioItem('Microsoft Corporation', 'MSFT', 30, 315.50, 290.00, 'Technology'),
    PortfolioItem('Amazon.com Inc.', 'AMZN', 15, 3300.00, 3200.00, 'E-commerce'),
    PortfolioItem('Vanguard Total Stock Market ETF', 'VTI', 100, 220.50, 200.00, 'Finance'),
    PortfolioItem('U.S. 10-Year Treasury Bond', 'US10Y', 50, 1000.00, 950.00, 'Bond'),
    PortfolioItem('Google LLC', 'GOOGL', 20, 2700.00, 2500.00, 'Technology'),
    PortfolioItem('General Motors', 'GM', 40, 55.00, 60.00, 'Automotive'),
  ];

  double _portfolioValue = 0;
  Map<String, double> sectorDistribution = {};

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
    _calculatePortfolioValue();
    _calculateSectorDistribution();
  }

  Future<void> _fetchTransactions() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final querySnapshot = await _firestore
          .collection('transactions')
          .where('userId', isEqualTo: user.uid)
          .get();

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        setState(() {
          portfolioItems.add(PortfolioItem(
            data['symbol'],
            data['symbol'],
            data['totalAmountBought'].toInt(),
            data['totalInvested'] / data['totalAmountBought'],
            data['totalInvested'] / data['totalAmountBought'],
            'User Added',
          ));
        });
      }

      _calculatePortfolioValue();
      _calculateSectorDistribution();
    }
  }

  Future<void> _addTransaction() async {
    String symbol = '';
    double totalAmountBought = 0;
    double totalInvested = 0;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Stock Transaction"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Stock Symbol"),
                onChanged: (value) {
                  symbol = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Total Amount Bought"),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  totalAmountBought = double.parse(value);
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Total Invested"),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  totalInvested = double.parse(value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                User? user = _auth.currentUser;
                if (user != null) {
                  final transaction = {
                    'symbol': symbol,
                    'totalAmountBought': totalAmountBought,
                    'totalInvested': totalInvested,
                    'date': DateTime.now().toIso8601String(),
                    'userId': user.uid,
                  };

                  await _firestore.collection('transactions').add(transaction);
                  Navigator.of(context).pop();
                  await _fetchTransactions();
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _calculatePortfolioValue() {
    double totalValue = 0;
    for (var item in portfolioItems) {
      totalValue += item.totalValue;
    }
    setState(() {
      _portfolioValue = totalValue;
    });
  }

  void _calculateSectorDistribution() {
    sectorDistribution.clear();
    for (var item in portfolioItems) {
      if (sectorDistribution.containsKey(item.sector)) {
        sectorDistribution[item.sector] = sectorDistribution[item.sector]! + item.totalValue;
      } else {
        sectorDistribution[item.sector] = item.totalValue;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio Manager'),
        backgroundColor: Color.fromARGB(255, 22, 3, 117),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(
                'Navigation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 22, 3, 117),
              ),
            ),
            ListTile(
              title: const Text('Behavioral Analysis'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => QuestionsPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Market Trend Analysis'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => StreamlitWebView3()),
                );
              },
            ),
            ListTile(
              title: const Text('Risk Assessment'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PredictionForm()),
                );
              },
            ),
            ListTile(
              title: const Text('Expenses Tracker'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => FinancialAdviceScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Recent News'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => StreamlitWebView4()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPortfolioSummary(),
            const SizedBox(height: 16),
            _buildSectorDistribution(),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: portfolioItems.length,
              itemBuilder: (context, index) {
                return PortfolioCard(portfolioItems[index]);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTransaction,
        child: const Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 22, 3, 117),
      ),
    );
  }

  Widget _buildPortfolioSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Portfolio Value',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Text(
            '\$${_portfolioValue.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
        ],
      ),
    );
  }

  Widget _buildSectorDistribution() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sector Distribution',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          ...sectorDistribution.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(entry.key, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                  Text('\$${entry.value.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class PortfolioItem {
  final String name;
  final String symbol;
  final double quantity;
  final double currentPrice;
  final double purchasePrice;
  final String sector;

  PortfolioItem(this.name, this.symbol, this.quantity, this.currentPrice, this.purchasePrice, this.sector);

  double get totalValue => quantity * currentPrice;
}

class PortfolioCard extends StatelessWidget {
  final PortfolioItem item;

  PortfolioCard(this.item);

  @override
  Widget build(BuildContext context) {
    double profitLoss = (item.currentPrice - item.purchasePrice) * item.quantity;
    bool isProfit = profitLoss >= 0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(item.symbol, style: TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Quantity: ${item.quantity.toStringAsFixed(2)}'),
                Text('Current Price: \$${item.currentPrice.toStringAsFixed(2)}'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Value: \$${item.totalValue.toStringAsFixed(2)}', 
                     style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  '${isProfit ? '+' : ''}\$${profitLoss.abs().toStringAsFixed(2)}',
                  style: TextStyle(
                    color: isProfit ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}