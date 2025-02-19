import 'package:flutter/material.dart';
import 'dart:async';

class GifTransitionScreen extends StatefulWidget {
  final Widget nextPage;

  GifTransitionScreen({required this.nextPage});

  @override
  _GifTransitionScreenState createState() => _GifTransitionScreenState();
}

class _GifTransitionScreenState extends State<GifTransitionScreen> {
  @override
  void initState() {
    super.initState();

    // Delay before transitioning to the next screen
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => widget.nextPage),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset("loc.gif", fit: BoxFit.cover),
      ),
    );
  }
}