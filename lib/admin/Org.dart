import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:typed_data';

import '../pages/college_login_screen.dart'; // Import login screen for navigation
import 'LoginScreen.dart';
import 'create_report.dart';

class Home2Page extends StatefulWidget {
  @override
  _Home2PageState createState() => _Home2PageState();
}

class _Home2PageState extends State<Home2Page> {
  bool isLoading = false;
  String extractedText = "";

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AdminLoginScreen()),
          (route) => false,
    );
  }

  Future<void> pickAndExtractPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        isLoading = true;
      });

      try {
        Uint8List fileBytes = result.files.single.bytes!;
        PdfDocument document = PdfDocument(inputBytes: fileBytes);
        String text = PdfTextExtractor(document).extractText();
        document.dispose();

        setState(() {
          isLoading = false;
          extractedText = text;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("PDF Uploaded Successfully")),
        );
      } catch (e) {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error extracting text: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
       // Light grey for better contrast
      appBar: AppBar(
        title: Text(

          "Firm Dashboard",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 19.0),
            child: IconButton(
              icon: Icon(Icons.logout, color: Colors.redAccent),
              onPressed: () => _logout(context),
              tooltip: "Logout",
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMenuItem(
                context,
                "New Report",
                "Enter crime data",
                Icons.note_add_outlined,
                Colors.blueAccent,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateReportorg()),
                  );
                },
              ),
              SizedBox(height: 20),
              _buildMenuItem(
                context,
                "Upload Document",
                "Upload and extract crime report",
                Icons.upload_file,
                Colors.green,
                pickAndExtractPDF,
              ),
              SizedBox(height: 20),
              if (isLoading) CircularProgressIndicator(),
              if (extractedText.isNotEmpty)
                Expanded(
                  child: SingleChildScrollView(
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          extractedText,
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}