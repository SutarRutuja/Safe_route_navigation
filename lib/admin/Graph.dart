import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class CrimeGraphScreen extends StatefulWidget {
  @override
  _CrimeGraphScreenState createState() => _CrimeGraphScreenState();
}

class _CrimeGraphScreenState extends State<CrimeGraphScreen> {
  Map<String, int> crimeCounts = {
    "Murder": 0,
    "Robbery": 0,
    "Assault": 0,
    "Domestic": 0,
  };

  @override
  void initState() {
    super.initState();
    _fetchCrimeData();
  }

  Future<void> _fetchCrimeData() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('crime_reports').get();

    int totalCrimes = snapshot.docs.length;

    if (totalCrimes == 0) return; // Avoid division by zero

    Map<String, int> counts = {
      "Murder": 0,
      "Robbery": 0,
      "Assault": 0,
      "Domestic": 0
    };

    for (var doc in snapshot.docs) {
      String type = doc['type'];
      if (counts.containsKey(type)) {
        counts[type] = counts[type]! + 1;
      }
    }

    setState(() {
      crimeCounts = counts.map((key, value) =>
          MapEntry(key, ((value / totalCrimes) * 100).round()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crime Report Statistics")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: BarChart(
          BarChartData(
            maxY: 100,
            barGroups: crimeCounts.entries.map((entry) {
              return BarChartGroupData(
                x: ["Murder", "Robbery", "Assault", "Domestic"]
                    .indexOf(entry.key),
                barRods: [
                  BarChartRodData(
                    toY: entry.value.toDouble(),
                    color: Colors.blue,
                    width: 20,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              );
            }).toList(),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: 10,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toInt()}%',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  getTitlesWidget: (value, meta) {
                    final crimes = ["Murder", "Robbery", "Assault", "Domestic"];
                    return Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        crimes[value.toInt()],
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              horizontalInterval: 10,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.grey.withOpacity(0.5),
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}