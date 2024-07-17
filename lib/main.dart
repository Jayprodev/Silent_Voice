import 'package:SilentVoice/Models/image_picker.dart';
import 'package:flutter/material.dart';
import 'splash.dart';
import 'brandintro.dart';
import 'login.dart';
import 'signup.dart';
import 'home.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SilentVoice',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/brandintro': (context) => BrandIntroScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/imagepicker': (context) => SimpleImagePicker(),
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _requestPermissions();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/brandintro');
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.accessibility, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              "Your Learning Partner",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestPermissions() async {
    await Permission.camera.request();
    await Permission.storage.request();
  }
}
