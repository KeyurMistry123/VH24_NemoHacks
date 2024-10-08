import 'package:flutter/material.dart';

void main() {
  runApp(InvestmentSuggestionApp());
}

class InvestmentSuggestionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Investment Suggestions',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: InvestmentSuggestionPage(),
    );
  }
}

class InvestmentSuggestionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> investmentOptions = [
      // Stocks
      {
        'Type': 'Blue-Chip Stocks',
        'Example': 'Reliance Industries Ltd. (RIL), HDFC Bank Ltd., Infosys Ltd., Tata Consultancy Services (TCS)',
        'Suggested %': '25%',
        'Current Rate': '7.0% annually',
      },
      {
        'Type': 'Dividend-Paying Stocks',
        'Example': 'ITC Ltd., Hindustan Unilever Ltd. (HUL), Coca-Cola India',
        'Suggested %': '15%',
        'Current Rate': '5.5% annually',
      },

      // Mutual Funds
      {
        'Type': 'Debt Mutual Funds',
        'Example': 'HDFC Short Term Debt Fund, ICICI Prudential Bond Fund, Axis Treasury Advantage Fund',
        'Suggested %': '20%',
        'Current Rate': '6.3% annually',
      },
      {
        'Type': 'Balanced Funds',
        'Example': 'HDFC Balanced Advantage Fund, ICICI Prudential Equity & Debt Fund',
        'Suggested %': '10%',
        'Current Rate': '8.1% annually',
      },
      {
        'Type': 'Index Funds',
        'Example': 'Nippon India Index Fund - Nifty 50 Plan, SBI Nifty Index Fund',
        'Suggested %': '10%',
        'Current Rate': '6.5% annually',
      },

      // Bonds
      {
        'Type': 'Government Securities (G-Secs)',
        'Example': '10-Year G-Sec Bonds, State Development Loans (SDLs)',
        'Suggested %': '20%',
        'Current Rate': '6.8% annually',
      },
      {
        'Type': 'Fixed Deposits (FDs)',
        'Example': 'Bank Fixed Deposits (SBI, HDFC Bank), Post Office Time Deposits',
        'Suggested %': '10%',
        'Current Rate': '5.7% annually',
      },

      // ETFs
      {
        'Type': 'Bond ETFs',
        'Example': 'Nippon India ETF Long Term Gilt, ICICI Prudential Nifty Next 50 ETF',
        'Suggested %': '15%',
        'Current Rate': '6.0% annually',
      },
      {
        'Type': 'Equity ETFs',
        'Example': 'SBI ETF Nifty 50, HDFC Nifty ETF',
        'Suggested %': '15%',
        'Current Rate': '7.5% annually',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Investment Suggestions'),
        backgroundColor: Colors.grey[900],
      ),
      body: SingleChildScrollView(
  padding: const EdgeInsets.all(16.0),
  child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Investment Suggestions for Low-Risk Profile',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Table(
              border: TableBorder.all(color: Colors.white),
              columnWidths: {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1.5),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[800]),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Investment Type',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Example',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Suggested %',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Current Rate',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                ...investmentOptions.map((option) {
                  return TableRow(
                    decoration: BoxDecoration(color: Colors.grey[850]),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          option['Type'],
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                          
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          option['Example'],
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          option['Suggested %'],
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          option['Current Rate'],
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
