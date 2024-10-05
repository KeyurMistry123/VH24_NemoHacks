import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PredictionsScreen extends StatefulWidget {
  @override
  _PredictionsScreenState createState() => _PredictionsScreenState();
}

class _PredictionsScreenState extends State<PredictionsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> _predictions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      _fetchPredictions(); // Fetch predictions for the current user
    }
  }

  Future<void> _fetchPredictions() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('predictions')
          .get();

      setState(() {
        _predictions = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        _loading = false;
      });
    } catch (e) {
      print("Error fetching predictions: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Predictions"),
        backgroundColor: Colors.deepPurple,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _predictions.isEmpty
              ? Center(child: Text("No predictions available."))
              : ListView.builder(
                  itemCount: _predictions.length,
                  itemBuilder: (context, index) {
                    final prediction = _predictions[index];
                    return ListTile(
                      title: Text("Input: ${prediction['input']}"),
                      subtitle: Text("Prediction: ${prediction['prediction']}"),
                      trailing: Text("User ID: ${prediction['userId']}"),
                    );
                  },
                ),
    );
  }
}
