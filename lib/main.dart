import 'package:SilentVoice/Models/add_contact.dart';
import 'package:SilentVoice/business/language_identification.dart';
import 'package:SilentVoice/business/messaging.dart';
import 'package:SilentVoice/business/sign_to_text.dart';
import 'package:SilentVoice/business/text_to_sign.dart';
import 'package:SilentVoice/business/voice_to_text.dart';
import 'package:SilentVoice/pages/brandintro.dart';
import 'package:SilentVoice/business/emergency_contacts.dart';
import 'package:SilentVoice/pages/home.dart';
import 'package:SilentVoice/pages/login.dart';
import 'package:SilentVoice/pages/settings.dart';
import 'package:SilentVoice/pages/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  double _fontSize = 16.0;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = ThemeMode.values[prefs.getInt('themeMode') ?? 0];
      _fontSize = prefs.getDouble('fontSize') ?? 16.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SilentVoice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: _fontSize),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: _fontSize),
        ),
      ),
      themeMode: _themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/brandintro': (context) => BrandIntroScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/text_to_sign': (context) => TextToSignScreen(),
        '/sign_to_text': (context) => SignToTextScreen(),
        '/voice_to_sign': (context) => VoiceToTextScreen(),
        '/language_identification': (context) => LanguageIdentificationScreen(),
        '/emergency_contacts': (context) => EmergencyContactsScreen(),
        '/settings': (context) => SettingsScreen(),
        '/messaging': (context) => MessagingScreen(),
      },
    );
  }
}

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

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pushReplacementNamed('/brandintro');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _requestPermissions();
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.accessibility, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              "Your communication and Learning Partner",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestPermissions() async {
    await Permission.camera.request();
    await Permission.storage.request();
    await Permission.microphone.request();
  }
}
