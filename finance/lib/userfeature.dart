import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // To format timestamps

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

  // Fetch predictions from Firestore
  Future<void> _fetchPredictions() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('predictions')
          .orderBy('timestamp', descending: true) // Sort by latest predictions
          .get();

      setState(() {
        _predictions = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        _loading = false;
      });
    } catch (e) {
      print("Error fetching predictions: $e");
    }
  }

  // Format timestamp to a readable string
  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yMMMd').add_jm().format(dateTime); // e.g., Oct 10, 2024, 5:30 PM
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile & Predictions"),
        backgroundColor: Color.fromARGB(255, 22, 3, 117),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/portfolio');
          },
        ),
        
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _buildProfileAndPredictions(),
    );
  }

  // Build the UI with user profile and predictions list
  Widget _buildProfileAndPredictions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User profile section
          _buildUserProfile(),

          SizedBox(height: 20),

          // Predictions header
          Text(
            'Your Predictions:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),

          // Show predictions list or no data message
          _predictions.isEmpty
              ? Center(child: Text("No predictions available."))
              : _buildPredictionsList(),
        ],
      ),
    );
  }

  // Build the user's profile section
  Widget _buildUserProfile() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.person, size: 50, color: Colors.deepPurple),
              title: Text(
                currentUser?.displayName ?? "User Name : Adrita Banerjee",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              subtitle: Text(
                currentUser?.email ?? "Email",
                style: TextStyle(color: Colors.grey[700]),
              ),
              trailing: Icon(Icons.edit, color: Colors.deepPurple),
            ),
          ],
        ),
      ),
    );
  }

  // Build predictions list
  Widget _buildPredictionsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _predictions.length,
      itemBuilder: (context, index) {
        final prediction = _predictions[index];
        final timestamp = prediction['timestamp'] as Timestamp;
        final input = prediction['input'] as Map<String, dynamic>;

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue[900]!, Colors.blue[700]!],
              ),
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.all(16.0),
              title: Text(
                "Prediction ${index + 1}",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                "Date: ${formatTimestamp(timestamp)}",
                style: TextStyle(color: Colors.white70),
              ),
              trailing: Icon(
                Icons.show_chart,
                color: Colors.white,
                size: 30,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Inputs:",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      ...input.entries.map((entry) => Padding(
                        padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
                        child: Text(
                          "${entry.key}: ${entry.value}",
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                      SizedBox(height: 16),
                      Text(
                        "Prediction: ${prediction['prediction']}",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
