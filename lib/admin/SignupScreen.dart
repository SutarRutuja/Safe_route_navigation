import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/college_login_screen.dart';
import 'LoginScreen.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String userType = "User"; // Default selection

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signUpUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Store user type in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("userType_${userCredential.user!.uid}", userType);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User registered successfully!")),
      );

      // Navigate directly to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminLoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

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
                    'Register',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: Image.asset(
                    'assets/login.png', // Replace with your image path
                    width:200,//Small image size
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),

                // User Type Selection using Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {

                        setState(() {
                          userType = "User";
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: userType == "User" ?Colors.pink : Colors.blueGrey,
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        'User',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    TextButton(

                      onPressed: () {
                        setState(() {
                          userType = "Reporter";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: userType == "Reporter" ? Colors.deepPurpleAccent : Colors.blueGrey,
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        'Reporter',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          userType = "Organization";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: userType == "Organization" ? Colors.teal : Colors.blueGrey,
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        'Firm',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),
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
                SizedBox(height: 30),

                Center(
                  child: ElevatedButton(
                    onPressed: signUpUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Black background
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AdminLoginScreen()),
                      );
                    },
                    child: Text(
                      'Already have an account? Sign In!',
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