// import 'package:flutter/material.dart';

// class ReportPage extends StatefulWidget {
//   @override
//   _ReportPageState createState() => _ReportPageState();
// }

// class _ReportPageState extends State<ReportPage> {
//   final TextEditingController locationController =
//   TextEditingController(text: "Balgandharva Rangmandir, Pune - 411005");
//   final TextEditingController radiusController = TextEditingController(text: "200");
//   final TextEditingController severityController = TextEditingController(text: "2");
//   final TextEditingController dateController = TextEditingController(text: "12/12/2012");
//   final TextEditingController timeController = TextEditingController(text: "16:00");

//   String selectedType = 'Theft'; // Initial selected value

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Report 1",
//           style: TextStyle(color: Colors.black),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context); // Navigate back
//           },
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Please update the below information correctly",
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
//               decoration: const InputDecoration(
//                 labelText: "Radius (in meters)",
//                 border: UnderlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Severity Input
//             TextField(
//               controller: severityController,
//               decoration: const InputDecoration(
//                 labelText: "Severity (1 to 4)",
//                 border: UnderlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Type Dropdown
//             DropdownButtonFormField<String>(
//               value: selectedType,
//               items: const [
//                 DropdownMenuItem(
//                   value: 'Murder',
//                   child: Text('Murder'),
//                 ),
//                 DropdownMenuItem(
//                   value: 'Robbery',
//                   child: Text('Robbery'),
//                 ),
//                 DropdownMenuItem(
//                   value: 'Assault',
//                   child: Text('Assault'),
//                 ),
//                 DropdownMenuItem(
//                   value: 'Domestic',
//                   child: Text('Domestic'),
//                 ),
//                 DropdownMenuItem(
//                   value: 'Theft',
//                   child: Text('Theft'),
//                 ),
//               ],
//               onChanged: (value) {
//                 setState(() {
//                   selectedType = value!;
//                 });
//               },
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
//                 onPressed: () {
//                   // Update logic here
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text(
//                   "Update information",
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