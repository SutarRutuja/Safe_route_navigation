import 'package:flutter/material.dart';
import 'dart:collection';

class CrimeReportPage extends StatelessWidget {
  final List<String> crimeList; // List of crime times

  CrimeReportPage({required this.crimeList});

  /// Function to find the most frequent time
  String getMostFrequentTime(List<String> times) {
    if (times.isEmpty) return "No data";

    Map<String, int> timeFrequency = {};

    // Count occurrences
    for (String time in times) {
      timeFrequency[time] = (timeFrequency[time] ?? 0) + 1;
    }

    // Sort by frequency in descending order
    var sortedEntries = timeFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.first.key; // Most frequent time
  }

  @override
  Widget build(BuildContext context) {
    String mostFrequentTime = getMostFrequentTime(crimeList);

    return Scaffold(
      appBar: AppBar(title: Text("Crime Report on Route")),
      body: crimeList.isEmpty
          ? Center(
        child: Text(
          "No crime data available for this route",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      )
          : Column(
        children: [
          // Display the most frequent crime time
          Card(
            margin: EdgeInsets.all(12),
            elevation: 4,
            child: ListTile(
              leading: Icon(Icons.crisis_alert, color: Colors.blue),
              title: Text(
                "Most Frequent Crime type $mostFrequentTime",
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Display the list of all crime times
          Expanded(
            child: ListView.builder(
              itemCount: crimeList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 0,
                  child: ListTile(
                    leading: Icon(Icons.multiline_chart_rounded, color: Colors.red),
                    title: Text(
                      crimeList[index],
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
