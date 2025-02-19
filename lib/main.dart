
import 'package:flutter/material.dart';
import 'package:flutter_application_2/admin/CreateReport.dart';
import 'package:flutter_application_2/admin/Dashboard.dart';
import 'package:flutter_application_2/admin/LoginScreen.dart';
import 'package:flutter_application_2/admin/SignupScreen.dart';
import 'package:flutter_application_2/app_features/Splashscreen.dart';
import 'package:flutter_application_2/pages/transition.dart';
import 'package:flutter_application_2/admin/hello.dart';
import 'package:flutter_application_2/maps/location_input.dart';
// import 'package:flutter_application_2/pages/view_report.dart';
import 'package:flutter_application_2/pages/edit_report.dart';
// import 'package:flutter_application_2/pages/new_report.dart';
// import 'pages/college_login_screen.dart'; // Assuming CollegeLoginScreen.dart is also under lib
// import 'pages/report_page.dart'; // Correctly referencing the file directly under lib
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_2/firebase_options.dart';
import 'package:flutter_application_2/pages/new_report.dart';
import 'package:flutter_application_2/pages/view_report.dart';
import 'package:google_fonts/google_fonts.dart';

import 'admin/ViewReport.dart';
import 'app_features/precautions_screen.dart';

// this  is  the final working type
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with default options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(), // Set Poppins globally
      ),
      //  // home:LocationScreen(),
      // home:HomePage(),
      home: WelcomeScreen(),
      // home: HomePage(),
      //home:Hello(),
    );
  }
}
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       // Define routes
//       routes: {
//         // '/': (context) => CollegeLoginScreen(), // Default screen
//         '/report': (context) => ReportPage(),  // Report Page route
//       },
//     );
//   }
// }