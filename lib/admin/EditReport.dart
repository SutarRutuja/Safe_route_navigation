import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../services/firestore.dart';
import 'DeleteReport.dart';

class EditReport extends StatefulWidget {
  @override
  _EditReportState createState() => _EditReportState();
}

class _EditReportState extends State<EditReport> {
  final FirestoreService firestoreService = FirestoreService();
  List<QueryDocumentSnapshot> reports = [];
  QueryDocumentSnapshot? selectedReport;

  final TextEditingController locationController = TextEditingController();
  final TextEditingController radiusController = TextEditingController();
  final TextEditingController severityController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();



  List<dynamic> _locationSuggestions = [];
  double? latitude;
  double? longitude;

  final String _nominatimUrl = "https://nominatim.openstreetmap.org/search";

  @override
  void initState() {
    super.initState();
    _fetchCrimeReports();
  }

  Future<void> _fetchCrimeReports() async {
    try {
      QuerySnapshot snapshot = await firestoreService.crimeReports.get();
      setState(() {
        reports = snapshot.docs;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load reports: $e")),
      );
    }
  }

  void _selectReport(QueryDocumentSnapshot report) {
    setState(() {
      selectedReport = report;
      var data = report.data() as Map<String, dynamic>;
      locationController.text = data['location'] ?? "";
      radiusController.text = data['radius'].toString();
      severityController.text = data['severity'].toString();
      typeController.text = data['type'] ?? "";
      dateController.text = data['date'] ?? "";
      timeController.text = data['time'] ?? "";
      descriptionController.text = data['description'] ?? "";
      latitude = data['latitude'];
      longitude = data['longitude'];
    });
  }

  Future<void> _fetchLocationSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() => _locationSuggestions = []);
      return;
    }

    try {
      final url = Uri.parse("$_nominatimUrl?q=$query&format=json&addressdetails=1&limit=5");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body);
        setState(() {
          _locationSuggestions = results;
        });
      } else {
        throw Exception("Failed to fetch location suggestions");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void _onSuggestionSelected(dynamic suggestion) {
    setState(() {
      locationController.text = suggestion['display_name'];
      latitude = double.tryParse(suggestion['lat']);
      longitude = double.tryParse(suggestion['lon']);
      _locationSuggestions = [];
    });
  }

  void updateReport() async {
    if (selectedReport == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a report to edit!")),
      );
      return;
    }

    try {
      await firestoreService.updateCrimeReport(selectedReport!.id, {
        'location': locationController.text,
        'radius': int.tryParse(radiusController.text) ?? 200,
        'severity': int.tryParse(severityController.text) ?? 2,
        'type': typeController.text,
        'date': dateController.text,
        'time': timeController.text,
        'description': descriptionController.text,
        'latitude': latitude,
        'longitude': longitude,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Report updated successfully!")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update report: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Update Report",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select a report to edit:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 10),

                if (reports.isEmpty)
                  const Center(child: CircularProgressIndicator())
                else
                  DropdownButtonFormField<QueryDocumentSnapshot>(
                    value: selectedReport,
                    hint: const Text("Select a report"),
                    isExpanded: true, // Prevents overflow
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: reports.map((report) {
                      var data = report.data() as Map<String, dynamic>;
                      return DropdownMenuItem<QueryDocumentSnapshot>(
                        value: report,
                        child: Text(data['location'] ?? "Unknown Location", overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (value) => _selectReport(value!),
                  ),

                const SizedBox(height: 20),

                _buildTextField("Location", locationController, onChanged: _fetchLocationSuggestions),
                if (_locationSuggestions.isNotEmpty) _buildSuggestionList(),
                _buildTextField("Radius (in meters)", radiusController, isNumber: true),
                _buildTextField("Severity (1 to 4)", severityController, isNumber: true),
                _buildTextField("Type of Crime", typeController),
                _buildTextField("Date (DD/MM/YYYY)", dateController),
                _buildTextField("Time (HH:MM)", timeController),
                _buildTextField("Crime description", descriptionController),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: updateReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Update Report",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false, Function(String)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionList() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: ListView.builder(
        itemCount: _locationSuggestions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_locationSuggestions[index]['display_name']),
            onTap: () => _onSuggestionSelected(_locationSuggestions[index]),
          );
        },
      ),
    );
  }
}
