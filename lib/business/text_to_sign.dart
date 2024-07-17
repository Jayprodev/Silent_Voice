import 'package:flutter/material.dart';
import 'sign_mapping.dart';

class TextToSignScreen extends StatefulWidget {
  @override
  _TextToSignScreenState createState() => _TextToSignScreenState();
}

class _TextToSignScreenState extends State<TextToSignScreen> {
  final _textController = TextEditingController();
  List<String> _signLanguageImages = [];
  bool _isLoading = false;

  void _convertTextToSign() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 4));

    setState(() {
      _signLanguageImages = _textController.text
          .toLowerCase()
          .split('')
          .where((char) => signMapping.containsKey(char))
          .map((char) => signMapping[char]!)
          .toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text to Sign"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter your message',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(15.0),
              ),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertTextToSign,
              child: _isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text('Convert to Sign'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                textStyle: TextStyle(fontSize: 18),
                backgroundColor: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _signLanguageImages.isEmpty
                      ? Center(
                          child: Text(
                            'Your translated sign language will appear here.',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Wrap(
                          spacing: 3.0,
                          runSpacing: 3.0,
                          children: _signLanguageImages
                              .map((imgPath) => Container(
                                    width: 60,
                                    height: 60,
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
