import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final String emergencyNumber = "tel:8999558734";
final String smsNumber = "8999558734";
final String emergencyMessage = "Help! I need immediate assistance.";

Future<void> makeEmergencyCall() async {
  final Uri url = Uri.parse(emergencyNumber);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    print("Could not launch $url");
  }
}

Future<void> sendEmergencySMS() async {
  final Uri smsUri = Uri.parse("sms:$smsNumber?body=${Uri.encodeComponent(emergencyMessage)}");

  if (await canLaunchUrl(smsUri)) {
    await launchUrl(smsUri);
  } else {
    print("Could not send SMS to $smsNumber");
  }
}

class EmergencyCallApp extends StatefulWidget {
  @override
  State<EmergencyCallApp> createState() => _EmergencyCallAppState();
}

class _EmergencyCallAppState extends State<EmergencyCallApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Emergency Contact")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Emergency Contact",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20), // Space between text and buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: makeEmergencyCall, // Call function when tapped
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
                  SizedBox(width: 20), // Space between call and SMS button
                  GestureDetector(
                    onTap: sendEmergencySMS, // SMS function when tapped
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.message,
                        color: Colors.white,
                        size:40,




                      ),
                    ),
                  ),
                  SizedBox(width: 20),


                  GestureDetector(
                    onTap: makeEmergencyCall, // Call function when tapped
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.green,
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
            ],
          ),
        ),
      ),
    );
  }
}







