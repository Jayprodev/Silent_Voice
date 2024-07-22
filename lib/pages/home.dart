import 'package:SilentVoice/business/language_identification.dart';
import 'package:SilentVoice/business/sign_to_text.dart';
import 'package:SilentVoice/business/text_to_sign.dart';
import 'package:SilentVoice/business/voice_to_text.dart';
import 'package:flutter/material.dart';
import 'navigation_drawer.dart' as customDrawer;
import 'package:shared_preferences/shared_preferences.dart';
import '../business/emergency_contacts.dart'; 

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  void _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName');
    });
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
                      "Hello, Good morning\n$userName",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Colors.blue),
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
                      "Image to Sign",
                      Icons.image,
                      () {},
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
                    IconButton(
                      icon: Icon(Icons.home, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.message, color: Colors.white),
                      onPressed: () {},
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
