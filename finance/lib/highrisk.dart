import 'package:flutter/material.dart';

class HighRiskInvestmentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'High-Risk Investment Suggestions',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: HighRiskInvestmentSuggestionPage(),
    );
  }
}

class HighRiskInvestmentSuggestionPage extends StatefulWidget {
  @override
  _HighRiskInvestmentSuggestionPageState createState() =>
      _HighRiskInvestmentSuggestionPageState();
}

class _HighRiskInvestmentSuggestionPageState
    extends State<HighRiskInvestmentSuggestionPage> {

  // Investment options list
  final List<Map<String, dynamic>> investmentOptions = [
    // Stocks
    {
      'Type': 'Growth Stocks',
      'Example':
          'Zomato Ltd., Paytm (One97 Communications Ltd.), Nykaa (FSN E-Commerce Ventures Ltd.), Adani Green Energy, Adani Ports',
      'Suggested %': '35%',
      'Current Rate': '12.5% annually',
    },
    {
      'Type': 'Small Cap Stocks',
      'Example':
          'Sutlej Textiles and Industries Ltd., Kansai Nerolac Paints Ltd., Mahindra Logistics Ltd.',
      'Suggested %': '20%',
      'Current Rate': '14.0% annually',
    },

    // Mutual Funds
    {
      'Type': 'Equity Mutual Funds',
      'Example':
          'Motilal Oswal Small Cap Fund, Axis Long Term Equity Fund (ELSS), Nippon India Growth Fund',
      'Suggested %': '20%',
      'Current Rate': '11.5% annually',
    },
    {
      'Type': 'Sectoral/Thematic Funds',
      'Example':
          'ICICI Prudential Technology Fund, HDFC Pharma Fund, Nippon India Banking Fund',
      'Suggested %': '15%',
      'Current Rate': '13.0% annually',
    },

    // ETFs
    {
      'Type': 'Sectoral ETFs',
      'Example': 'Nippon India ETF Nifty Next 50, ICICI Prudential Nifty Bank ETF',
      'Suggested %': '10%',
      'Current Rate': '9.0% annually',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Show the risk alert dialog only once when the page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showRiskAlert(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('High-Risk Investment Suggestions'),
        backgroundColor: Colors.grey[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/portfolio');
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Investment Suggestions for High-Risk Profile',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            _buildInvestmentTable(),
          ],
        ),
      ),
    );
  }

  // Function to build the investment table
  Widget _buildInvestmentTable() {
    return Table(
      border: TableBorder.all(color: Colors.white),
      columnWidths: {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1.5),
      },
      children: [
        _buildTableHeader(),
        ...investmentOptions.map((option) {
          return TableRow(
            decoration: BoxDecoration(color: Colors.grey[850]),
            children: [
              _buildTableCell(option['Type']),
              _buildTableCell(option['Example']),
              _buildTableCell(option['Suggested %']),
              _buildTableCell(option['Current Rate']),
            ],
          );
        }).toList(),
      ],
    );
  }

  // Function to build the table header
  TableRow _buildTableHeader() {
    return TableRow(
      decoration: BoxDecoration(color: Colors.grey[800]),
      children: [
        _buildHeaderCell('Investment Type'),
        _buildHeaderCell('Example'),
        _buildHeaderCell('Suggested %'),
        _buildHeaderCell('Current Rate'),
      ],
    );
  }

  // Function to build table header cells
  Widget _buildHeaderCell(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Function to build table content cells
  Widget _buildTableCell(String content) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        content,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  // Function to show alert popup
  void showRiskAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            'Risk Tolerance: High Risk',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'High-risk investments can lead to significant losses; ensure you\'re comfortable with this level of risk.\n\n'
            'Diversification: Diversifying your portfolio can help mitigate some risks while pursuing higher returns.\n\n'
            'Investment Horizon: These investments typically require a longer investment horizon to ride out volatility.',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
