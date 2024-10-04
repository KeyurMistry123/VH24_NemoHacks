import 'package:flutter/material.dart';

class RecommendationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Investment Recommendations'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Mid-Term Recommendations Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Mid-Term Recommendations',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    DataTable(
                      columns: const <DataColumn>[
                        DataColumn(label: Text('Company Name')),
                        DataColumn(label: Text('Last Trading Price (LTP)')),
                        DataColumn(label: Text('Entry')),
                        DataColumn(label: Text('Target')),
                        DataColumn(label: Text('Holding Period')),
                        DataColumn(label: Text('Details')),
                      ],
                      rows: const <DataRow>[
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Bank First Corp. (BFC)',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text('\$ 72.28')),
                            DataCell(Text('\$ 75.00')),
                            DataCell(Text('\$ 98.50')),
                            DataCell(Text('~ 1 year')),
                            DataCell(
                              ElevatedButton(
                                onPressed: null,
                                child: Text('View Details'),
                              ),
                            ),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('ACNB Corp. (ACNB)',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text('\$ 29.13')),
                            DataCell(Text('\$ 30.50')),
                            DataCell(Text('\$ 40.30')),
                            DataCell(Text('~ 1.5 years')),
                            DataCell(
                              ElevatedButton(
                                onPressed: null,
                                child: Text('View Details'),
                              ),
                            ),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Axos Financials INC. (AX)',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text('\$ 48.53')),
                            DataCell(Text('\$ 50.20')),
                            DataCell(Text('\$ 62.75')),
                            DataCell(Text('~ 2 years')),
                            DataCell(
                              ElevatedButton(
                                onPressed: null,
                                child: Text('View Details'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Long-Term Recommendations Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Long-Term Recommendations',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    DataTable(
                      columns: const <DataColumn>[
                        DataColumn(label: Text('Company Name')),
                        DataColumn(label: Text('Last Trading Price (LTP)')),
                        DataColumn(label: Text('Fundamental Strength')),
                        DataColumn(label: Text('Expected Returns (CAGR)')),
                        DataColumn(label: Text('Holding Period')),
                        DataColumn(label: Text('Details')),
                      ],
                      rows: const <DataRow>[
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Molina Healthcare INC. (MOL)',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text('\$ 240.98')),
                            DataCell(Text('Strong',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text('+ 12.29 %',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold))),
                            DataCell(Text('~ 4 years')),
                            DataCell(
                              ElevatedButton(
                                onPressed: null,
                                child: Text('View Details'),
                              ),
                            ),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Public Storage (PSA)',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text('\$ 257.88')),
                            DataCell(Text('Good',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text('+ 11.23 %',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold))),
                            DataCell(Text('~ 5 years')),
                            DataCell(
                              ElevatedButton(
                                onPressed: null,
                                child: Text('View Details'),
                              ),
                            ),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Best Buy Co. (BBY)',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text('\$ 112.48')),
                            DataCell(Text('Very Strong',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text('+ 19.96 %',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold))),
                            DataCell(Text('~ 3 years')),
                            DataCell(
                              ElevatedButton(
                                onPressed: null,
                                child: Text('View Details'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Footer
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('© All Rights Reserved ${DateTime.now().year}'),
              Text('Crafted with ❤️'),
            ],
          ),
        ),
      ),
    );
  }
}