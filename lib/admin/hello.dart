import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Hello extends StatefulWidget {
  @override
  _HelloState createState() => _HelloState();
}

class _HelloState extends State<Hello> {
  late FlutterTts flutterTts;
  List<String> textList = [
    "Hello, welcome to Flutter!",
    "This is a text-to-speech example.",
    "Enjoy coding with Flutter and Dart!"
  ];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
  }

  Future _speak() async {
    if (currentIndex < textList.length) {
      await flutterTts.speak(textList[currentIndex]);
      setState(() {
        currentIndex++;
      });
    }
  }

  Future _reset() async {
    setState(() {
      currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text-to-Speech List"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentIndex < textList.length ? textList[currentIndex] : "Done!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _speak,
              child: Text("Read Next"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _reset,
              child: Text("Reset"),
            ),
          ],
        ),
      ),
    );
  }
}
