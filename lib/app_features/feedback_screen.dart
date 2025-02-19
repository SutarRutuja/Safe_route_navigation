import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() {
runApp(MaterialApp(
debugShowCheckedModeBanner: false,
home: FeedbackScreen(),
));
}

class FeedbackScreen extends StatefulWidget {
@override
_FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
double _rating = 0; // Store rating value
TextEditingController _feedbackController = TextEditingController(); // Controller for text field

void _submitFeedback() {
String feedback = _feedbackController.text;
// Handle feedback submission (e.g., send to a database)
print("Rating: $_rating");
print("Feedback: $feedback");

// Show confirmation message
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text("Thank you for your feedback!")),
);

// Clear the input
_feedbackController.clear();
setState(() {
_rating = 0;
});
}

@override
Widget build(BuildContext context) {
return Scaffold(
  backgroundColor: Colors.white,
appBar: AppBar(title: Text("Feedback")),
body: SingleChildScrollView(  // Add scrollable functionality to prevent overflow
padding: const EdgeInsets.all(16.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.center,
children: [
// Image at the top with fill style
Container(
height: 290,
width: double.infinity,
child: Image.asset(
"assets/feedback.png", // Make sure you add this image to your assets folder
fit: BoxFit.cover,
),
),

SizedBox(height: 20), // Adding space between image and feedback box

// Rating and Feedback Box with black border
Container(
padding: EdgeInsets.all(16),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(12),
border: Border.all(color: Colors.black), // Black border
boxShadow: [
BoxShadow(
color: Colors.grey.withOpacity(0.2),
blurRadius: 5,
spreadRadius: 2,
),
],
),
child: Column(
children: [
Text("Rate Us", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

SizedBox(height: 10),

// Star Rating
RatingBar.builder(
initialRating: 0,
minRating: 1,
direction: Axis.horizontal,
allowHalfRating: false,
itemCount: 5,
itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
onRatingUpdate: (rating) {
setState(() {
_rating = rating;
});
},
),

SizedBox(height: 20),

// Experience Text Field
TextField(
controller: _feedbackController,
maxLines: 3,
decoration: InputDecoration(
labelText: "Was your  route really safe"
    "",
border: OutlineInputBorder(),
),
),

SizedBox(height: 20),

// Submit Button
ElevatedButton(

onPressed: _submitFeedback,
child: Text("Submit"),




),
],
),
),
],
),
),
);
}
}