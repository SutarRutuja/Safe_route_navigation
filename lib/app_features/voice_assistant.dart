import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechScreen extends StatefulWidget {
  final List<String> directions;

  TextToSpeechScreen({required this.directions});

  @override
  _TextToSpeechScreenState createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  FlutterTts flutterTts = FlutterTts();
  bool _isSpeaking = false; // Track whether speaking is active

  /// Reads directions one by one every 15 seconds
  Future<void> speakDirections() async {
    setState(() {
      _isSpeaking = true;
    });

    for (int i = 0; i < widget.directions.length; i++) {
      if (!_isSpeaking) break; // Stop loop if speaking was stopped

      await flutterTts.speak(widget.directions[i]);

      // Wait 15 seconds or until speaking is stopped
      for (int j = 0; j < 5; j++) {
        if (!_isSpeaking) break;
        await Future.delayed(Duration(seconds: 1));
      }
    }

    setState(() {
      _isSpeaking = false;
    });
  }

  Future<void> stop() async {
    await flutterTts.stop();
    setState(() {
      _isSpeaking = false; // Mark as stopped
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Navigation Guide-Astra")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Press Speak to start navigation guidance.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: _isSpeaking ? null : speakDirections, // Disable when speaking
              child: Text("Speak Directions"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isSpeaking ? stop : null, // Disable when not speaking
              child: Text("Stop"),

            ),
            SizedBox(height: 20,),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/astra.png',  // Make sure this image is in your assets folder
                  height: 100,
                ),
                SizedBox(height: 20),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "        Hello I am Astra your                     navigator assistant",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }
}