import 'package:flutter/material.dart';

void main() {
  runApp(MediumRiskInvestmentApp());
}

class MediumRiskInvestmentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medium-Risk Investment Suggestions',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: MediumRiskInvestmentSuggestionPage(),
    );
  }
}

class MediumRiskInvestmentSuggestionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> investmentOptions = [
      // Stocks
      {
        'Type': 'Growth Stocks',
        'Example': 'HDFC Bank Ltd., Asian Paints Ltd., Bajaj Finance Ltd., Maruti Suzuki India Ltd.',
        'Suggested %': '30%',
        'Current Rate': '10.0% annually',
      },
      {
        'Type': 'Sectoral Stocks (Pharma & Tech)',
        'Example': 'Dr. Reddy\'s Laboratories, Sun Pharma, Infosys, TCS',
        'Suggested %': '20%',
        'Current Rate': '9.5% annually',
      },

      // Mutual Funds
      {
        'Type': 'Equity Mutual Funds',
        'Example': 'SBI Small Cap Fund, HDFC Mid-Cap Opportunities Fund, ICICI Prudential Growth Fund',
        'Suggested %': '25%',
        'Current Rate': '11.5% annually',
      },
      {
        'Type': 'Hybrid Mutual Funds',
        'Example': 'HDFC Balanced Advantage Fund, ICICI Prudential Equity & Debt Fund',
        'Suggested %': '15%',
        'Current Rate': '9.0% annually',
      },

      // ETFs
      {
        'Type': 'Equity ETFs',
        'Example': 'Nippon India ETF Nifty 50, ICICI Prudential Nifty Next 50 ETF',
        'Suggested %': '15%',
        'Current Rate': '8.5% annually',
      },

      // Bonds & Fixed Income
      {
        'Type': 'Corporate Bonds',
        'Example': 'High-rated Corporate Bonds (HDFC Ltd., Tata Motors Finance Bonds)',
        'Suggested %': '10%',
        'Current Rate': '7.5% annually',
      },
      {
        'Type': 'Debt Mutual Funds',
        'Example': 'HDFC Corporate Bond Fund, ICICI Prudential Credit Risk Fund',
        'Suggested %': '10%',
        'Current Rate': '6.8% annually',
      },

      // Other Investments
      {
        'Type': 'Real Estate Investment Trusts (REITs)',
        'Example': 'Mindspace Business Parks REIT, Brookfield India Real Estate Trust',
        'Suggested %': '10%',
        'Current Rate': '7.1% annually',
      },
      {
        'Type': 'Gold Investments',
        'Example': 'Sovereign Gold Bonds, Gold ETFs',
        'Suggested %': '10%',
        'Current Rate': 'Variable',
      },
      {
        'Type': 'Public Provident Fund (PPF)',
        'Example': 'Public Provident Fund (PPF)',
        'Suggested %': '5%',
        'Current Rate': '7.1% annually',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Medium-Risk Investment Suggestions'),
        backgroundColor: Colors.grey[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Investment Suggestions for Medium-Risk Profile',
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
