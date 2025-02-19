import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/services/firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
class DeleteReport extends StatefulWidget {
  const DeleteReport({Key? key}) : super(key: key);

  @override
  _DeleteReportState createState() => _DeleteReportState();
}

class _DeleteReportState extends State<DeleteReport> {
  final FirestoreService firestoreService = FirestoreService();
  String selectedCategory = "Murder";
  final List<String> categories = ["Murder", "Robbery", "Assault", "Domestic", "Theft"];
  Map<String, bool> selectedReports = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delete Report", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryTabs(),
              const SizedBox(height: 16),
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

                    var reports = snapshot.data!.docs.where((doc) {
                      var data = doc.data() as Map<String, dynamic>;
                      return data['type'] == selectedCategory;
                    }).toList();

                    return ListView.builder(
                      itemCount: reports.length,
                      itemBuilder: (context, index) {
                        var report = reports[index];
                        Map<String, dynamic> data = report.data() as Map<String, dynamic>;
                        String reportId = report.id;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey),
                              color: Colors.white,
                            ),
                            child: ListTile(
                              title: Text(
                                data['location'] ?? 'Unknown Location',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              trailing: Checkbox(
                                value: selectedReports[reportId] ?? false,
                                onChanged: (bool? value) {
                                  setState(() {
                                    selectedReports[reportId] = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              _buildDeleteButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((category) {
            bool isSelected = selectedCategory == category;
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = category;
                    selectedReports.clear();
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

  Widget _buildDeleteButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _deleteSelectedReports,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text("Delete Report", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  void _deleteSelectedReports() async {
    try {
      List<String> idsToDelete = selectedReports.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      if (idsToDelete.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No reports selected for deletion")),
        );
        return;
      }

      for (String id in idsToDelete) {
        await firestoreService.deleteCrimeReport(id);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selected reports deleted successfully")),
      );

      setState(() {
        selectedReports.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting reports: $e")),
      );
    }
  }
}