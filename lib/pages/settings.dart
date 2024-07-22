import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ThemeMode _themeMode = ThemeMode.system;
  double _fontSize = 16.0;

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

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeMode', _themeMode.index);
    prefs.setDouble('fontSize', _fontSize);
  }

  void _changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
    _saveSettings();
  }

  void _changeFontSize(double fontSize) {
    setState(() {
      _fontSize = fontSize;
    });
    _saveSettings();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/home');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Theme',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: Text('System Default'),
                leading: Radio<ThemeMode>(
                  value: ThemeMode.system,
                  groupValue: _themeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      _changeTheme(value);
                    }
                  },
                ),
              ),
              ListTile(
                title: Text('Light'),
                leading: Radio<ThemeMode>(
                  value: ThemeMode.light,
                  groupValue: _themeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      _changeTheme(value);
                    }
                  },
                ),
              ),
              ListTile(
                title: Text('Dark'),
                leading: Radio<ThemeMode>(
                  value: ThemeMode.dark,
                  groupValue: _themeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      _changeTheme(value);
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Font Size',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Slider(
                value: _fontSize,
                min: 12,
                max: 24,
                divisions: 12,
                label: _fontSize.round().toString(),
                onChanged: (double value) {
                  _changeFontSize(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
