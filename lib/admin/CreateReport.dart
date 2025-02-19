import 'package:flutter/material.dart';
import 'package:flutter_application_2/services/firestore.dart'; // Firestore service
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';


class CreateReport extends StatefulWidget {
  @override
  _CreateReportState createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReport> {
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController locationController = TextEditingController();
  final TextEditingController radiusController =
  TextEditingController(text: "200");
  final TextEditingController severityController =
  TextEditingController(text: "2");
  final TextEditingController typeController =
  TextEditingController(text: "Theft");
  final TextEditingController dateController =
  TextEditingController(text: "12/12/2012");
  final TextEditingController timeController =
  TextEditingController(text: "16:00");
  final TextEditingController descriptionController = TextEditingController();



  // String selectedCrimeType = "Murder"; // Ensure this exists in crimeTypes

  List<dynamic> _locationSuggestions = [];
  double? latitude;
  double? longitude;

  final String _nominatimUrl = "https://nominatim.openstreetmap.org/search";

  // Fetch location suggestions from Nominatim API
  Future<void> _fetchLocationSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() => _locationSuggestions = []);
      return;
    }

    try {
      final url = Uri.parse(
          "$_nominatimUrl?q=$query&format=json&addressdetails=1&limit=5");
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

  // Handle location suggestion selection
  void _onSuggestionSelected(dynamic suggestion) {
    setState(() {
      locationController.text = suggestion['display_name'];
      latitude = double.tryParse(suggestion['lat']);
      longitude = double.tryParse(suggestion['lon']);
      _locationSuggestions = [];
    });
  }

  // Save crime report to Firestore
  void saveCrimeReport() async {
    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a valid location!")),
      );
      return;
    }

    try {
      await firestoreService.addCrimeReport(
        location: locationController.text,
        radius: int.tryParse(radiusController.text) ?? 200,
        severity: int.tryParse(severityController.text) ?? 2,
        type: typeController.text,
        date: dateController.text,
        time: timeController.text,
        description: descriptionController.text,
        latitude: latitude!,
        longitude: longitude!,
        // panel:"Admin",    it was of boolean logic
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Crime report saved successfully!")),
      );

      // Clear all fields after saving
      locationController.clear();
      radiusController.text = "200";
      severityController.text = "2";
      typeController.text = "Theft";
      dateController.text = "12/12/2012";
      timeController.text = "16:00";
      setState(() {
        latitude = null;
        longitude = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save report: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Report", style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Please update the below information correctly",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 20),

              // Location Input with Auto-Suggestions
              TextField(
                controller: locationController,
                onChanged: _fetchLocationSuggestions,
                decoration: const InputDecoration(
                  labelText: "Location",
                  border: UnderlineInputBorder(),
                ),
              ),
              if (_locationSuggestions.isNotEmpty)
                Container(
                  height: 150,
                  child: ListView.builder(
                    itemCount: _locationSuggestions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title:
                        Text(_locationSuggestions[index]['display_name']),
                        onTap: () =>
                            _onSuggestionSelected(_locationSuggestions[index]),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),

              if (latitude != null && longitude != null)
                Text(
                  "Selected Coordinates: $latitude, $longitude",
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              const SizedBox(height: 16),

              // Radius Input
              TextField(
                controller: radiusController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Radius (in meters)",
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Severity Input
              TextField(
                controller: severityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Severity (0-4)",
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: typeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Type of crime",
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              //for dropdown
              

              // Date Input
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: "Date (DD/MM/YYYY)",
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Time Input
              TextField(
                controller: timeController,
                decoration: const InputDecoration(
                  labelText: "Time (HH:MM)",
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),

              //Text description
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "Enter description",
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveCrimeReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, // Black button
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Save Crime Information",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}