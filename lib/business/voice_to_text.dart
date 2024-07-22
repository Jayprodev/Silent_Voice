import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'sign_mapping.dart';  // Assuming you have a mapping of signs for text

class VoiceToTextScreen extends StatefulWidget {
  @override
  _VoiceToTextScreenState createState() => _VoiceToTextScreenState();
}

class _VoiceToTextScreenState extends State<VoiceToTextScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "";
  List<String> _signLanguageImages = [];

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
            _convertTextToSign(_text);
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

  void _convertTextToSign(String text) {
    setState(() {
      _signLanguageImages = text
          .toLowerCase()
          .split('')
          .where((char) => signMapping.containsKey(char))
          .map((char) => signMapping[char]!)
          .toList();
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
        title: Text("Voice to Sign and Text"),
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
            Expanded(
              child: _signLanguageImages.isEmpty
                  ? Center(
                      child: Text(
                        'Your translated sign language will appear here.',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: _signLanguageImages
                          .map((imgPath) => Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(imgPath),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
