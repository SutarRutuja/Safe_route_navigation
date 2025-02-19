import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../services/firestore.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Graph.dart';
// Import the new graph screen



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'firestore_service.dart';
// import 'crime_graph_screen.dart';

class ViewReport extends StatefulWidget {
  const ViewReport({Key? key}) : super(key: key);

  @override
  _ViewReportState createState() => _ViewReportState();
}

class _ViewReportState extends State<ViewReport> {
  final FirestoreService firestoreService = FirestoreService();
  String selectedCategory = "Murder"; // Default selected category
  final List<String> categories = [
    "Murder", "Assault", "Domestic", "Theft",
    "Vandalism", "Burglary", "Fraud", "Drug-related", "Other"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("View Reports", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart, color: Colors.black), // Graph button
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CrimeGraphScreen()), // Navigate to graph screen
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryTabs(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestoreService.getCrimeReportsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No reports found"));
                }

                // Retrieve list of reports filtered by selected category
                var reports = snapshot.data!.docs.where((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  return data['type'] == selectedCategory;
                }).toList();

                return ListView.builder(
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    var report = reports[index];
                    Map<String, dynamic> data = report.data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(
                          data['location'] ?? 'Unknown Location',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Type: ${data['type']}"),
                            Text("Severity: ${data['severity']}"),
                            Text("Radius: ${data['radius']} meters"),
                            Text("Date: ${data['date']}"),
                            Text("Time: ${data['time']}"),
                            Text("Description: ${data['description']}"),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteReport(report.id, context),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Function to delete a report
  void _deleteReport(String docId, BuildContext context) async {
    try {
      await firestoreService.deleteCrimeReport(docId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Report deleted successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting report: $e")),
      );
    }
  }

  // Category Tabs widget (Fixed overflow issue)
  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView( // <-- Wrap Row with scrollable container
        scrollDirection: Axis.horizontal, // <-- Allow horizontal scrolling
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: categories.map((category) {
            bool isSelected = selectedCategory == category;
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = category;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected ? null : Border.all(color: Colors.grey),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
