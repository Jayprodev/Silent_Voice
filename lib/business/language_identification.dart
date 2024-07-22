import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class LanguageIdentificationScreen extends StatefulWidget {
  @override
  _LanguageIdentificationScreenState createState() => _LanguageIdentificationScreenState();
}

class _LanguageIdentificationScreenState extends State<LanguageIdentificationScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "";
  String _identifiedLanguage = "";
  String _translatedText = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initializeSpeechRecognition();
  }

  Future<void> _initializeSpeechRecognition() async {
    bool isPermissionGranted = await _getMicrophonePermission();
    await _handlePermissionResponse(isPermissionGranted);
  }

  Future<bool> _getMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      var result = await Permission.microphone.request();
      return result.isGranted;
    }
    return true;
  }

  Future<void> _handlePermissionResponse(bool isPermissionGranted) async {
    if (isPermissionGranted) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (!available) {
        print('The user has denied the use of speech recognition.');
      }
    } else {
      print('Microphone permission not granted');
    }
  }

  bool _isSpeechRecognitionAvailable() {
    return _speech.isAvailable;
  }

  void _startSpeechRecognition() {
    if (!_isListening) {
      _speech.listen(
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
            _identifyLanguage(_text);
          });
        },
        listenFor: Duration(minutes: 1),
        cancelOnError: true,
      );
      setState(() {
        _isListening = true;
      });
    }
  }

  void _stopSpeechRecognition() {
    if (_isListening) {
      _speech.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  Future<void> _identifyLanguage(String text) async {
    final translator = GoogleTranslator();
    final translation = await translator.translate(text, to: 'en');  // Assuming 'en' as the target language
    final detectedLanguage = translation.sourceLanguage.name;

    setState(() {
      _identifiedLanguage = detectedLanguage;
      _translatedText = translation.text;
    });
  }

  @override
  void dispose() {
    _disposeSpeechRecognition();
    super.dispose();
  }

  void _disposeSpeechRecognition() {
    _speech.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Language Identification"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              _text,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSpeechRecognitionAvailable()
                  ? _startSpeechRecognition
                  : null,
              child: Text(_isListening ? 'Listening...' : 'Start Listening'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                textStyle: TextStyle(fontSize: 18),
                backgroundColor: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _stopSpeechRecognition,
              child: Text('Stop Listening'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                textStyle: TextStyle(fontSize: 18),
                backgroundColor: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Identified Language: $_identifiedLanguage',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 10),
            Text(
              'Translated Text: $_translatedText',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
