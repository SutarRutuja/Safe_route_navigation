// import 'package:flutter/material.dart';
// import 'package:flutter_application_2/services/firestore.dart'; // Import Firestore service
//
// class NewReport extends StatefulWidget {
//   @override
//   _NewReportState createState() => _NewReportState();
// }
//
// class _NewReportState extends State<NewReport> {
//   final FirestoreService firestoreService = FirestoreService();
//
//   final TextEditingController locationController =
//       TextEditingController(text: "Balgandharva Rangmandir, Pune - 411005");
//   final TextEditingController radiusController =
//       TextEditingController(text: "200");
//   final TextEditingController severityController =
//       TextEditingController(text: "2");
//   final TextEditingController typeController =
//       TextEditingController(text: "Theft");
//   final TextEditingController dateController =
//       TextEditingController(text: "12/12/2012");
//   final TextEditingController timeController =
//       TextEditingController(text: "16:00");
//
//   // Function to save data to Firestore
//   void saveCrimeReport() async {
//     try {
//       await firestoreService.addCrimeReport(
//         location: locationController.text,
//         radius: int.tryParse(radiusController.text) ?? 0,
//         severity: int.tryParse(severityController.text) ?? 0,
//         type: typeController.text,
//         date: dateController.text,
//         time: timeController.text,
//       );
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Crime report saved successfully!")),
//       );
//
//       // Clear the fields after saving
//       locationController.clear();
//       radiusController.clear();
//       severityController.clear();
//       typeController.clear();
//       dateController.clear();
//       timeController.clear();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to save report: $e")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "New Report",
//           style: TextStyle(color: Colors.black),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Please update the below information correctly",
//                 style: TextStyle(fontSize: 14, color: Colors.black54),
//               ),
//               const SizedBox(height: 20),
//               // Location Input
//               TextField(
//                 controller: locationController,
//                 decoration: const InputDecoration(
//                   labelText: "Location",
//                   border: UnderlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               // Radius Input
//               TextField(
//                 controller: radiusController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   labelText: "Radius (in meters)",
//                   border: UnderlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               // Severity Input
//               TextField(
//                 controller: severityController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   labelText: "Severity (1 to 4)",
//                   border: UnderlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               // Type Input
//               TextField(
//                 controller: typeController,
//                 decoration: const InputDecoration(
//                   labelText: "Type of Crime",
//                   border: UnderlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               // Date Input
//               TextField(
//                 controller: dateController,
//                 decoration: const InputDecoration(
//                   labelText: "Date (DD/MM/YYYY)",
//                   border: UnderlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               // Time Input
//               TextField(
//                 controller: timeController,
//                 decoration: const InputDecoration(
//                   labelText: "Time (HH:MM)",
//                   border: UnderlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               // Save Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: saveCrimeReport, // Call the save function
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Text(
//                     "Save Crime Information",
//                     style: TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
