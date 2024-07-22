import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'sign_mapping.dart';

class SignToTextScreen extends StatefulWidget {
  @override
  _SignToTextScreenState createState() => _SignToTextScreenState();
}

class _SignToTextScreenState extends State<SignToTextScreen> {
  File? _image;
  String _translatedText = "";

  final picker = ImagePicker();

  Future<void> _getImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _translateImageToText();
        });
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _translateImageToText() {
    // Placeholder for image recognition logic
    setState(() {
      _translatedText = _recognizeSignFromImage(_image);
    });
  }

  String _recognizeSignFromImage(File? image) {
    if (image == null) return "No image selected";

    // Placeholder logic for recognizing sign from image
    String fileName = image.path.split('/').last.toLowerCase();
    if (signMapping.containsValue('lib/assets/$fileName')) {
      return signMapping.keys.firstWhere((k) => signMapping[k] == 'lib/assets/$fileName');
    } else {
      return "Sign not recognized";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign to Text"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_image != null) 
              Image.file(
                _image!,
                height: 200,
                width: 200,
              ),
            if (_image == null)
              Text(
                'No image selected.',
                style: TextStyle(fontSize: 18),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _getImage(ImageSource.camera),
              child: Text('Capture Image'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                textStyle: TextStyle(fontSize: 18),
                backgroundColor: Colors.blue,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _getImage(ImageSource.gallery),
              child: Text('Upload Image'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                textStyle: TextStyle(fontSize: 18),
                backgroundColor: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            Text(
              _translatedText,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
