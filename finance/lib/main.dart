import 'package:finance/analysisrisk.dart';
import 'package:finance/chatbot.dart';
import 'package:finance/dashboard.dart';
import 'package:finance/factors.dart';
import 'package:finance/login_screen.dart';
import 'package:finance/portfolio.dart';
import 'package:finance/questionnaire.dart';
import 'package:finance/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'factors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Future<FirebaseApp> initialization = Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyA3AArnUovKnHDaV7KTEI2i91n55pW_wFs",
      appId: "1:137430080200:android:819703b0ccebfabb3423fd",
      messagingSenderId: "137430080200",
      projectId: "fintech-vcet",
    ),
  );

  runApp(MyApp(initialization: initialization));
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> initialization;

  // Add the 'key' parameter to the constructor
  const MyApp({super.key, required this.initialization});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              appBar: AppBar(
                title: const Text("Initializing..."),
              ),
              body: const Center(
                child: CircularProgressIndicator(), // Display during loading
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              appBar: AppBar(
                title: const Text("Error initializing Firebase"),
              ),
              body: const Center(
                child: Text("Something went wrong!"), // Display error message
              ),
            ),
          );
        }

        return Builder(builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,

            // Define routes for all the pages in your app
            initialRoute: '/login',
            routes: {
              '/login': (context) => LoginPage(key: const Key("LoginScreen")),
              '/signup': (context) => SignUpPage(key: const Key("RegistrationScreen")),
              '/questionnaire': (context) => QuestionsPage(),
              '/risk_analysis': (context) => PredictionForm(), // Assuming you have a RiskAnalysisPage widget
              '/chatbot': (context) => FinancialAdviceScreen(), 
              // Assuming you have a ChatbotPage widget
            },
            theme: ThemeData.dark(), // Ensure this is set correctly
          );
        });
      },
    );
  }
}
