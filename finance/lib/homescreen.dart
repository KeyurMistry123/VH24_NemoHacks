import 'dart:ui';

import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(141, 134, 201, 1),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomeScreen(title: "Home"),
    );
  }
}


  
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required String title});
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

 
}


