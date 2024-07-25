import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Timer(Duration(seconds: 5), () {
        Navigator.of(context).pushReplacementNamed('/brandintro');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.accessibility, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              "Your communication and learning Partner",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
