import 'package:SilentVoice/business/messaging.dart';
import 'package:SilentVoice/business/speech_to_text.dart';
import 'package:SilentVoice/business/language_identification.dart';
import 'package:SilentVoice/business/profile.dart';
import 'package:SilentVoice/business/sign_to_text.dart';
import 'package:SilentVoice/business/text_to_sign.dart';
import 'package:SilentVoice/business/voice_to_text.dart';
import 'package:flutter/material.dart';
import 'navigation_drawer.dart' as customDrawer;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../business/emergency_contacts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String imagePath = await _getProfileImagePath();
    setState(() {
      userName = prefs.getString('userName');
      if (imagePath.isNotEmpty) {
        _profileImage = File(imagePath);
      }
    });
  }

  Future<String> _getProfileImagePath() async {
    final Database db = await _initDatabase();
    List<Map<String, dynamic>> results = await db.query('profile', where: 'id = ?', whereArgs: [1]);
    if (results.isNotEmpty) {
      return results.first['imagePath'];
    }
    return '';
  }

  Future<Database> _initDatabase() async {
    String dbPath = join(await getDatabasesPath(), 'silentvoice.db');
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE profile(
            id INTEGER PRIMARY KEY,
            imagePath TEXT
          )
        ''');
      },
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else if (hour < 20) {
      return 'Good evening';
    } else {
      return 'Good night';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SilentVoice'),
        backgroundColor: Colors.blue,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: customDrawer.NavigationDrawer(),
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hello, ${_getGreeting()}\n$userName",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage()),
                        );
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            _profileImage != null ? FileImage(_profileImage!) : null,
                        child: _profileImage == null
                            ? Icon(Icons.person, color: Colors.blue, size: 30)
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  children: [
                    _buildFeatureCard(
                      context,
                      "Text to Sign",
                      Icons.text_fields,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TextToSignScreen()),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      "Speech to Text",
                      Icons.mic_external_on,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SpeechToTextScreen()),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      "Voice to Sign",
                      Icons.mic,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VoiceToTextScreen()),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      "Sign to Text",
                      Icons.translate,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignToTextScreen()),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      "Emergency Contacts",
                      Icons.contacts,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EmergencyContactsScreen()),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      "Language Identification",
                      Icons.language,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LanguageIdentificationScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // IconButton(
                    //   icon: Icon(Icons.home, color: Colors.white),
                    //   onPressed: () {},
                    // ),
                    IconButton(
                      icon: Icon(Icons.message, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MessagingScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, IconData icon, Function onTap) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () => onTap(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            SizedBox(height: 10),
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
