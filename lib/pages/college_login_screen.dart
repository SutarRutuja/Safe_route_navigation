// import 'package:flutter/material.dart';
// import 'package:flutter_application_2/pages/new_report.dart';
// import 'report_page.dart'; // Relative import


// class CollegeLoginScreen extends StatefulWidget {
//   @override
//   _CollegeLoginScreenState createState() => _CollegeLoginScreenState();
// }

// class _CollegeLoginScreenState extends State<CollegeLoginScreen> {
//   bool isUser = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: Column(
//           children: [
//             // "Sign in" text at the top, centered
//             const SizedBox(height: 40),
//             const Center(
//               child: Text(
//                 'Sign in',
//                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 100), // Space between "Sign in" and radio buttons

//             // Row for image and radio buttons
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Radio Buttons and Labels
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Row(
//                         children: [
//                           Radio(
//                             value: true,
//                             groupValue: isUser,
//                             onChanged: (value) {
//                               setState(() {
//                                 isUser = value!;
//                               });
//                             },
//                           ),
//                           const Text('User'),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Radio(
//                             value: false,
//                             groupValue: isUser,
//                             onChanged: (value) {
//                               setState(() {
//                                 isUser = value!;
//                               });
//                             },
//                           ),
//                           const Text('Reporter'),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 10), // Space between radio buttons and image
//                 // Image from assets
//                 Container(
//                   height: 200,
//                   width: 200,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.black, width: 3),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Image.asset(
//                       'assets/images/map.jpg', // Replace with your image path
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             // Username and Password blocks centered vertically
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const TextField(
//                     decoration: InputDecoration(
//                       labelText: 'Username',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   const TextField(
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 40), // Space between password and Login button

//                   // Login Button
//                   ElevatedButton(
//                     onPressed: () {
//                       // Navigate to the ReportPage after login
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => NewReport()),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                       padding:
//                       const EdgeInsets.symmetric(vertical: 14, horizontal: 150),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text(
//                       'Login',
//                       style: TextStyle(fontSize: 18, color: Colors.white),
//                     ),
//                   ),
//                   const SizedBox(height: 10), // Space between Login button and Register link

//                   // Register Link
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pushNamed(context, '/register');
//                     },
//                     child: const Text(
//                       'New User? Register here',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }