

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Firestore collection reference
  final CollectionReference crimeReports = FirebaseFirestore.instance.collection('crime_reports');

  // Add a new crime report to Firestore
  Future<void> addCrimeReport({
    required String location,
    required int radius,
    required int severity,
    required String type,
    required String date,
    required String time,
    required String description,
    required double latitude, required double longitude,
  }) {
    return crimeReports.add({
      'location': location,
      'radius': radius,
      'severity': severity,
      'latitude': latitude, // Latitude value
      'longitude': longitude,
      'type': type,
      'date': date,
      'time': time,
      'timestamp': Timestamp.now(),
      'description':description,
    });
  }



  // Get stream of crime reports ordered by timestamp
  Stream<QuerySnapshot> getCrimeReportsStream() {
    return crimeReports.orderBy('timestamp', descending: true).snapshots();
  }

  // Update an existing crime report
  Future<void> updateCrimeReport(String docId, Map<String, dynamic> updatedData) {
    return crimeReports.doc(docId).update(updatedData);
  }

  // Delete a crime report
  Future<void> deleteCrimeReport(String docId) {
    return crimeReports.doc(docId).delete();
  }
    Future<QuerySnapshot> getCrimeReportsByLocation(double lat, double lng) async {
      return FirebaseFirestore.instance
          .collection('crime_reports')
          .where('latitude', isEqualTo: lat)
          .where('longitude', isEqualTo: lng)
          .get();
    }

}
