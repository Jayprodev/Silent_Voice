import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _profileImage;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      String imagePath = await _getProfileImagePath();

      setState(() {
        _nameController.text = userDoc['name'];
        _emailController.text = user.email!;
        _phoneController.text = userDoc['phoneNumber'];
        if (imagePath.isNotEmpty) {
          _profileImage = File(imagePath);
        }
      });
    }
  }

  Future<String> _getProfileImagePath() async {
    final Database db = await _initDatabase();
    List<Map<String, dynamic>> results = await db.query('profile', where: 'id = ?', whereArgs: [1]);
    if (results.isNotEmpty) {
      return results.first['imagePath'];
    }
    return '';
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      await _saveProfileImage(pickedFile.path);
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'profileImage': pickedFile.path,
        });
      }
    }
  }

  Future<void> _saveProfileImage(String path) async {
    final Database db = await _initDatabase();
    await db.insert(
      'profile',
      {'id': 1, 'imagePath': path},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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

  Future<void> _saveProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': _nameController.text,
        'phoneNumber': _phoneController.text,
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', _nameController.text);
    }
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blue,
        actions: [
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveProfile,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? Icon(Icons.person, size: 60, color: Colors.white)
                      : null,
                ),
              ),
              SizedBox(height: 20),
              _buildEditableTextField(
                controller: _nameController,
                label: 'Name',
                enabled: _isEditing,
              ),
              SizedBox(height: 20),
              _buildEditableTextField(
                controller: _emailController,
                label: 'Email',
                enabled: false,
              ),
              SizedBox(height: 20),
              _buildEditableTextField(
                controller: _phoneController,
                label: 'Phone Number',
                enabled: _isEditing,
              ),
              SizedBox(height: 20),
              if (!_isEditing)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  child: Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableTextField({
    required TextEditingController controller,
    required String label,
    required bool enabled,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      enabled: enabled,
    );
  }
}
