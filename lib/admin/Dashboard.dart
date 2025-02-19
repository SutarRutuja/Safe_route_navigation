
import 'package:flutter/material.dart';
import 'package:flutter_application_2/admin/CreateReport.dart';
import 'package:flutter_application_2/admin/EditReport.dart';
import '../pages/view_report.dart';
import 'package:flutter_application_2/admin/DeleteReport.dart';

import 'LoginScreen.dart';
import 'ViewReport.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../pages/college_login_screen.dart'; // Import login screen for navigation

class HomePage extends StatelessWidget {
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AdminLoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey for better contrast
      appBar: AppBar(
        title: Text(
          "Admin Dashboard",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 19.0), // Moves logout button left by ~0.5cm
            child: IconButton(
              icon: Icon(Icons.logout, color: Colors.redAccent),
              onPressed: () => _logout(context), // Call logout function
              tooltip: "Logout",
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1, // Ensures square tiles
                ),
                itemBuilder: (context, index) {
                  List<Map<String, dynamic>> menuItems = [
                    {
                      "title": "New Report",
                      "subtitle": "Enter crime data",
                      "icon": Icons.note_add_outlined,
                      "color": Colors.blueAccent,
                      "page": CreateReport(),
                    },
                    {
                      "title": "Update Report",
                      "subtitle": "Modify existing report",
                      "icon": Icons.edit_note_outlined,
                      "color": Colors.orangeAccent,
                      "page": EditReport(),
                    },
                    {
                      "title": "View",
                      "subtitle": "View Report",
                      "icon": Icons.view_kanban_rounded,
                      "color": Colors.greenAccent,
                      "page": ViewReport(),
                    },
                    {
                      "title": "Delete Report",
                      "subtitle": "Remove Report data",
                      "icon": Icons.delete_outline,
                      "color": Colors.redAccent,
                      "page": DeleteReport(),
                    },
                  ];

                  return _buildMenuItem(
                    context,
                    menuItems[index]["title"],
                    menuItems[index]["subtitle"],
                    menuItems[index]["icon"],
                    menuItems[index]["color"],
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => menuItems[index]["page"]),
                      );
                    },
                  );
                },
              ),
            ),
          ],
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