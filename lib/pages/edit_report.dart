// import 'package:flutter/material.dart';
// import 'package:flutter_application_2/services/firestore.dart';
//
// class EditReport extends StatefulWidget {
//   final String docId;
//   final Map<String, dynamic> reportData;
//
//   const EditReport({super.key, required this.docId, required this.reportData});
//
//   @override
//   _EditReportState createState() => _EditReportState();
// }
//
// class _EditReportState extends State<EditReport> {
//   final FirestoreService firestoreService = FirestoreService();
//
//   late TextEditingController locationController;
//   late TextEditingController radiusController;
//   late TextEditingController severityController;
//   late TextEditingController typeController;
//   late TextEditingController dateController;
//   late TextEditingController timeController;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Initialize controllers with existing data
//     locationController = TextEditingController(text: widget.reportData['location']);
//     radiusController = TextEditingController(text: widget.reportData['radius'].toString());
//     severityController = TextEditingController(text: widget.reportData['severity'].toString());
//     typeController = TextEditingController(text: widget.reportData['type']);
//     dateController = TextEditingController(text: widget.reportData['date']);
//     timeController = TextEditingController(text: widget.reportData['time']);
//   }
//
//   // Function to update the report in Firestore
//   void updateReport() async {
//     try {
//       await firestoreService.updateCrimeReport(widget.docId, {
//         'location': locationController.text,
//         'radius': int.tryParse(radiusController.text) ?? 0,
//         'severity': int.tryParse(severityController.text) ?? 0,
//         'type': typeController.text,
//         'date': dateController.text,
//         'time': timeController.text,
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Report updated successfully!")),
//       );
//
//       Navigator.pop(context);  // Go back to the previous page
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to update report: $e")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Edit Report",
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
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Edit the report details below",
//               style: TextStyle(fontSize: 14, color: Colors.black54),
//             ),
//             const SizedBox(height: 20),
//             // Location Input
//             TextField(
//               controller: locationController,
//               decoration: const InputDecoration(
//                 labelText: "Location",
//                 border: UnderlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Radius Input
//             TextField(
//               controller: radiusController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: "Radius (in meters)",
//                 border: UnderlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Severity Input
//             TextField(
//               controller: severityController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: "Severity (1 to 4)",
//                 border: UnderlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Type Input
//             TextField(
//               controller: typeController,
//               decoration: const InputDecoration(
//                 labelText: "Type",
//                 border: UnderlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Date Input
//             TextField(
//               controller: dateController,
//               decoration: const InputDecoration(
//                 labelText: "Date",
//                 border: UnderlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Time Input
//             TextField(
//               controller: timeController,
//               decoration: const InputDecoration(
//                 labelText: "Time",
//                 border: UnderlineInputBorder(),
//               ),
//             ),
//             const Spacer(),
//             // Update Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: updateReport,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text(
//                   "Update Report",
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
