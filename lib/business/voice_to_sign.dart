import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'sign_mapping.dart';

class VoiceToSignScreen extends StatefulWidget {
  @override
  _VoiceToSignScreenState createState() => _VoiceToSignScreenState();
}

class _VoiceToSignScreenState extends State<VoiceToSignScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "";
  List<String> _signLanguageImages = [];

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
            _text = val.recognizedWords;
            _convertTextToSign(_text);
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
              onPressed: _listen,
              child: Icon(_isListening ? Icons.mic : Icons.mic_none),
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
