import 'package:SilentVoice/Models/add_contact.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

class EmergencyContactsScreen extends StatefulWidget {
  @override
  _EmergencyContactsScreenState createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  late Database _database;
  List<Map<String, dynamic>> _contacts = [];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    _database = await openDatabase(
      p.join(await getDatabasesPath(), 'contacts.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE contacts(id INTEGER PRIMARY KEY, name TEXT, phone TEXT, email TEXT)",
        );
      },
      version: 1,
    );
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    final List<Map<String, dynamic>> contacts = await _database.query('contacts');
    setState(() {
      _contacts = contacts;
    });
  }

  Future<void> _addContact(String name, String phone, String email) async {
    await _database.insert(
      'contacts',
      {'name': name, 'phone': phone, 'email': email},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _fetchContacts();
  }

  Future<void> _deleteContact(int id) async {
    await _database.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
    _fetchContacts();
  }

  Future<void> _makeCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  void _showAddContactDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddContactScreen()),
    ).then((result) {
      if (result != null && result is Map<String, String>) {
        _addContact(result['name']!, result['phone']!, result['email']!);
      }
    });
  }

  void _showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Contact'),
          content: Text('Are you sure you want to delete this contact?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteContact(id);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Contacts'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(_contacts[index]['id'].toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _showDeleteConfirmationDialog(_contacts[index]['id']);
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ListTile(
                title: Text(
                  _contacts[index]['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _contacts[index]['phone'],
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                    if (_contacts[index]['email'] != null && _contacts[index]['email'].isNotEmpty)
                      Text(_contacts[index]['email']),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.call, color: Colors.green),
                  onPressed: () => _makeCall(_contacts[index]['phone']),
                ),
                onTap: () => _makeCall(_contacts[index]['phone']),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddContactDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
