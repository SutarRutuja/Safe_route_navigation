import 'package:flutter/material.dart';

class PrecautionScreen extends StatelessWidget {
  final List<Map<String, String>> precautions = [
    {
      'title': 'Avoid High-Crime Areas',
      'description':
      'Plan your route carefully and avoid areas with a known history of crimes. Use real-time crime data to identify and bypass risky locations. Stick to well-lit streets and populated neighborhoods.',
      'image': 'assets/avoid.png',
    },
    {
      'title': 'Travel During Safe Hours',
      'description':
      'Avoid traveling late at night or during early hours when streets are deserted. Opt for travel during daylight or peak hours when more people are around, reducing the risk of potential threats.',
      'image': 'assets/travel.png',
    },
    {
      'title': 'Emergency Contact Setup',
      'description':
      'Before heading out, share your route with a trusted contact using location-sharing apps. Save emergency helpline numbers and have them readily accessible in case of trouble.',
      'image': 'assets/emergency.png',
    },
    {
      'title': 'Use Public Transport Safely',
      'description':
      'When using public transport, sit in well-occupied sections and avoid empty carriages. Ensure your phone is charged and refrain from sharing your location details with strangers.',
      'image': 'assets/public_bus.png',
    },
    {
      'title': 'Install Safety Apps',
      'description':
      'Download safety apps that provide features like real-time location tracking, emergency SOS buttons, and alerts for high-risk areas. These apps can act as your digital companion while traveling.',
      'image': 'assets/install.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Safe Route Tips & Advice',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blueAccent,

      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: precautions.length,
          separatorBuilder: (context, index) => SizedBox(height: 20),
          itemBuilder: (context, index) {
            return SafetyCard(
              title: precautions[index]['title']!,
              description: precautions[index]['description']!,
              imagePath: precautions[index]['image']!,
            );
          },
        ),
      ),
    );
  }
}

class SafetyCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  SafetyCard({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.shade300, width: 1.5),
      ),
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey.shade300,
                    child: Icon(Icons.image_not_supported, size: 50, color: Colors.red),
                  );
                },
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

