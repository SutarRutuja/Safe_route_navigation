import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';



class EmergencyCallApp1 extends StatefulWidget {
  @override
  _EmergencyCallAppState createState() => _EmergencyCallAppState();
}

class _EmergencyCallAppState extends State<EmergencyCallApp1> {
  // Text editing controller to capture the user input
  final TextEditingController _phoneController = TextEditingController();

  // Function to make an emergency call
  Future<void> _makeEmergencyCall(String phoneNumber) async {
    final Uri url = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Emergency Call")),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Emergency Call",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                // Phone number input field
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Enter Phone Number",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20), // Space between text field and button
                GestureDetector(
                  onTap: () {
                    // Get the phone number from text field and make the call
                    String phoneNumber = _phoneController.text;
                    if (phoneNumber.isNotEmpty) {
                      _makeEmergencyCall(phoneNumber);
                    } else {
                      print("Please enter a valid phone number.");
                    }
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.call,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}