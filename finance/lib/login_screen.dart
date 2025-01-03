import 'package:finance/analysisrisk.dart';
import 'package:finance/chatbot.dart';
import 'package:finance/portfolio.dart';
import 'package:finance/questionnaire.dart';
import 'package:finance/registration_screen.dart';
import 'package:finance/userfeature.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
class LoginPage extends StatefulWidget {
  // Add the 'key' parameter to the constructor
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String? _email, _password;

  Future<void> _login() async {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();
      final localContext = context; // Capture the context before the async gap
      try {
        await _auth.signInWithEmailAndPassword(
            email: _email!, password: _password!);
        Navigator.pushReplacement(
          localContext, // Use the captured context
          MaterialPageRoute(
              builder: (context) =>
                  PortfolioScreen()), // Navigate to VideosScreen
        );
      } on FirebaseAuthException catch (e) {
        print(e.message);
        ScaffoldMessenger.of(localContext)
            .showSnackBar(// Use the captured context
                SnackBar(content: Text(e.message ?? 'Unknown error occurred')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Colors.white,
                Colors.white,
                Colors.white,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 80,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeInUp(
                        duration: Duration(milliseconds: 1000),
                        child: Text("Login",
                            style:
                                TextStyle(color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold))),
                    SizedBox(
                      height: 10,
                    ),
                    FadeInUp(
                        duration: Duration(milliseconds: 1300),
                        child: Text("Welcome Back",
                            style:
                                TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 22, 3, 117),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60)),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 60,
                          ),
                          FadeInUp(
                            duration: Duration(milliseconds: 1400),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(255, 255, 255, 0.29),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  )
                                ],
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black)),
                                      ),
                                      child: TextFormField(
                                        validator: (input) =>
                                            input?.isEmpty == true
                                                ? 'Enter your email'
                                                : null,
                                        onSaved: (input) => _email = input,
                                        decoration: InputDecoration(
                                          hintText: "Email or Phone number",
                                          hintStyle:
                                              TextStyle(color: Colors.black),
                                          border: InputBorder.none,
                                        ),
                                        style: TextStyle(color: Colors.black)
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black)),
                                      ),
                                      child: TextFormField(
                                        obscureText: true,
                                        validator: (input) =>
                                            input?.isEmpty == true
                                                ? 'Enter your password'
                                                : null,
                                        onSaved: (input) => _password = input,
                                        decoration: InputDecoration(
                                          hintText: "Password",
                                          hintStyle:
                                              TextStyle(color: Colors.black),
                                          border: InputBorder.none,
                                        ),
                                        style: TextStyle(color: Colors.black)
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          FadeInUp(
                              duration: Duration(milliseconds: 1500),
                              child: Text("Forgot Password?",
                                  style: TextStyle(color: Colors.white))),
                          SizedBox(
                            height: 40,
                          ),
                          FadeInUp(
                            duration: Duration(milliseconds: 1600),
                            child: MaterialButton(
                              onPressed: _login,
                              height: 50,
                              color: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Text("Login",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FadeInUp(
                            duration: Duration(milliseconds: 1700),
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/signup');
                              },
                              child: Text("Don't have an account? Sign up",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
