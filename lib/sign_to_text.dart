import 'package:flutter/material.dart';

class SignToTextScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Language to Text'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Implement sign language to text functionality
              },
              child: Text('Capture Sign Language'),
            ),
          ],
        ),
      ),
    );
  }
}
