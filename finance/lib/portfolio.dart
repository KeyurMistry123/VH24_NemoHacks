import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  // Hardcoded portfolio data with sectors
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
    _calculatePortfolioValue();
    _calculateSectorDistribution();
  }

  // Calculate the total portfolio value
  void _calculatePortfolioValue() {
    double totalValue = 0;
    for (var item in portfolioItems) {
      totalValue += item.totalValue;
    }
    setState(() {
      _portfolioValue = totalValue;
    });
  }

  // Calculate the distribution of investments by sector
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
        title: Text('Portfolio Manager'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.grey[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPortfolioSummary(),
            SizedBox(height: 16),
            _buildSectorDistribution(),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: portfolioItems.length,
                itemBuilder: (context, index) {
                  return PortfolioCard(portfolioItems[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Portfolio summary displaying total value
  Widget _buildPortfolioSummary() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Portfolio Value',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            '\$${_portfolioValue.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Sector distribution of the portfolio
  Widget _buildSectorDistribution() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sector Distribution',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Column(
            children: sectorDistribution.entries.map((entry) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  Text(
                    '\$${entry.value.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class PortfolioItem {
  final String name;
  final String ticker;
  final int quantity;
  double currentPrice;
  final double purchasePrice;
  final String sector;

  PortfolioItem(
    this.name,
    this.ticker,
    this.quantity,
    this.currentPrice,
    this.purchasePrice,
    this.sector,
  );

  double get totalValue => quantity * currentPrice;
  double get returns => (currentPrice - purchasePrice) * quantity;
  double get percentageReturn => ((currentPrice - purchasePrice) / purchasePrice) * 100;
}

class PortfolioCard extends StatelessWidget {
  final PortfolioItem portfolioItem;

  PortfolioCard(this.portfolioItem);

  @override
  Widget build(BuildContext context) {
    bool isPositive = portfolioItem.currentPrice > portfolioItem.purchasePrice;

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  portfolioItem.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Icon(
                  isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: isPositive ? Colors.green : Colors.red,
                  size: 30,
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              '${portfolioItem.quantity} units @ \$${portfolioItem.currentPrice.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            SizedBox(height: 10),
            Text(
              'Purchased @ \$${portfolioItem.purchasePrice.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Value: \$${portfolioItem.totalValue.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Returns: \$${portfolioItem.returns.toStringAsFixed(2)} (${portfolioItem.percentageReturn.toStringAsFixed(2)}%)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isPositive ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
