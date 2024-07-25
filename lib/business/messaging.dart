// lib/business/messaging.dart
import 'package:SilentVoice/Models/sign_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:url_launcher/url_launcher.dart';

class MessagingScreen extends StatefulWidget {
  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _message = "Type your message";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _messageController.text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _message = val.recognizedWords;
            }
          }),
        );
      } else {
        setState(() => _isListening = false);
        _speech.stop();
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _sendMessage() async {
    String phoneNumber = _phoneNumberController.text;
    String message = _messageController.text;

    if (phoneNumber.isNotEmpty && message.isNotEmpty) {
      final Uri launchUri = Uri(
        scheme: 'sms',
        path: phoneNumber,
        queryParameters: {'body': message},
      );
      await launch(launchUri.toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a phone number and message')),
      );
    }
  }

  void _onKeyPressed(String letter) {
    setState(() {
      _messageController.text += letter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messaging'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Message',
                suffixIcon: IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  onPressed: _listen,
                ),
              ),
              maxLines: null,
            ),
            SizedBox(height: 20),
            Expanded(
              child: SignKeyboard(
                onKeyPressed: _onKeyPressed,
              ),
            ),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Send Message'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
