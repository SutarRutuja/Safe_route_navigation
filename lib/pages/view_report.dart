// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_application_2/services/firestore.dart';
//
// class ViewReport extends StatelessWidget {
//   final FirestoreService firestoreService = FirestoreService();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "View Reports",
//           style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: firestoreService.getCrimeReportsStream(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (snapshot.hasError) {
//             return Center(
//               child: Text("Error: ${snapshot.error}"),
//             );
//           }
//
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text("No reports found"),
//             );
//           }
//
//           // Retrieve list of reports
//           var reports = snapshot.data!.docs;
//
//           return ListView.builder(
//             itemCount: reports.length,
//             itemBuilder: (context, index) {
//               var report = reports[index];
//               Map<String, dynamic> data = report.data() as Map<String, dynamic>;
//
//               return Card(
//                 margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: ListTile(
//                   title: Text(
//                     data['location'] ?? 'Unknown Location',
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Type: ${data['type']}"),
//                       Text("Severity: ${data['severity']}"),
//                       Text("Radius: ${data['radius']} meters"),
//                       Text("Date: ${data['date']}"),
//                       Text("Time: ${data['time']}"),
//                     ],
//                   ),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.delete, color: Colors.red),
//                     onPressed: () => _deleteReport(report.id, context),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   // Function to delete a report
//   void _deleteReport(String docId, BuildContext context) async {
//     try {
//       await firestoreService.deleteCrimeReport(docId);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Report deleted successfully")),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error deleting report: $e")),
//       );
//     }
//   }
// }
//the above codes work properly