import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 120,  // Adjust the height as needed
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'SilentVoice',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.text_fields),
            title: Text('Text to Sign'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/text_to_sign');
            },
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text('Image to Sign'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/image_to_sign');
            },
          ),
          ListTile(
            leading: Icon(Icons.mic),
            title: Text('Voice to Sign'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/voice_to_sign');
            },
          ),
          ListTile(
            leading: Icon(Icons.translate),
            title: Text('Sign to Text'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/sign_to_text');
            },
          ),
          ListTile(
            leading: Icon(Icons.camera),
            title: Text('Emergency Contacts'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/emergency_contacts');
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language Identification'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/language_identification');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/settings');
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Log Out'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
    );
  }
}
