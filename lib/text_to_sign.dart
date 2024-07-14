import 'package:flutter/material.dart';

class TextToSignScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text to Sign Language'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Enter text'),
            ),
            ElevatedButton(
              onPressed: () {
                // Translate text to sign language
              },
              child: Text('Translate'),
            ),
          ],
        ),
      ),
    );
  }
}
