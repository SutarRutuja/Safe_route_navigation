import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../maps/location_input.dart';
import '../admin/Dashboard.dart';
import 'Org.dart';
import 'SignupScreen.dart';


class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  /// 🔹 *Check if user is already logged in & redirect accordingly*
  void checkLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userType = prefs.getString("userType_${user.uid}");

      if (userType == "User") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LocationScreen()),
        );
      } else if (userType == "Reporter") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()), // Admin screen
        );
      } else if (userType == "Organization") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home2Page()), // Organization screen
        );
      }
    }
  }

  /// 🔹 *Login function*
  void loginUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userType = prefs.getString("userType_${userCredential.user!.uid}");

      if (userType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User role not found. Please sign up again.")),
        );
        return;
      }

      // Navigate to respective screens based on user type
      if (userType == "User") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LocationScreen()),
        );
      } else if (userType == "Reporter") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()), // Admin screen
        );
      } else if (userType == "Organization") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home2Page()), // Organization screen
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  /// 🔹 *Reset Password Dialog*
  void openResetPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Reset Password", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Enter your email', border: OutlineInputBorder()),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (emailController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter your email")));
                      return;
                    }
                    try {
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password reset email sent!")));
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
                    }
                  },
                  child: Text("Send Reset Email"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 🔹 *Login UI*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Center(
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                /// 🔹 *Image Placeholder*
                Center(
                  child: Image.asset(
                    'assets/login.png', // Replace with your image path
                    width:200,//Small image size
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Id',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: openResetPasswordDialog,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: loginUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                    child: Text(
                      "Don't have an account? Sign Up!",
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


