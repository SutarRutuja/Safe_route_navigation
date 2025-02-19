import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminForgotPasswordScreen extends StatefulWidget {
  @override
  _AdminForgotPasswordScreenState createState() => _AdminForgotPasswordScreenState();
}

class _AdminForgotPasswordScreenState extends State<AdminForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  void resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password reset link sent!")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error sending reset email")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Enter your email")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: resetPassword, child: Text("Reset Password")),
          ],
        ),
      ),
    );
  }
}