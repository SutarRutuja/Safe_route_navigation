import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
// Function to get severity score with improved query and tolerance
Future<Object?> getSeverityScore(LatLng point) async
{
  try {
    double tolerance = 0.001; // Adjust for precision differences
    // Fetch all documents (Firestore does not support direct float range queries)
    QuerySnapshot query = await firestore.collection("crime_reports").get();
  //latlong search imp
   // print("Searching for: Latitude = ${point.latitude}, Longitude = ${point.longitude}");

    for (var doc in query.docs) {
      double docLatitude = double.parse(doc["latitude"].toString());  // Ensure it's double
      double docLongitude = double.parse(doc["longitude"].toString());

      print("Checking document: Latitude = $docLatitude, Longitude = $docLongitude");

      // Compare with absolute difference
      double latDiff = (point.latitude - docLatitude).abs();
      double longDiff = (point.longitude - docLongitude).abs();

     // print("Latitude Difference: $latDiff, Longitude Difference: $longDiff");

      if (latDiff <= tolerance && longDiff <= tolerance) {
        print("Match found! Severity Score: ${doc["severity"] ?? 0}");
        return doc["severity"] ?? 0; // Return severity score
      }
    }

    print("No match found.");
    return 0; // Return 0 if no match
  } catch (e) {
    print("Error fetching severity for (${point.latitude}, ${point.longitude}): $e");
    return 0; // Return 0 in case of error
  }
}

// Function to process route and get severity scores
Future<void> processRoute(List<LatLng> route, String routeType) async {
  print("----- $routeType Route Safety Scores -----");
  print("route is $routeType");
  print(route);

  for (int i = 1; i < route.length - 1; i++) { // Exclude start and end points
    LatLng point = route[i];
    Object? severity = await getSeverityScore(point);
    print("$routeType Route Point: (${point.latitude}, ${point.longitude}) -> Severity Score: $severity");
  }
}


Future<int> calculateTotalSafetyScore(List<LatLng> route, String routeType) async {
  int totalScore = 0;
  int count =0;


  for (int i = 1; i < route.length - 1; i++) { // Exclude start and end points
    LatLng point = route[i];

    Object? severityObj = await getSeverityScore(point); // Get severity score
    int severity = (severityObj as int?) ?? 0; // Safely cast to int

    totalScore += severity; // Add the severity to the total score
    count++;
  }

  print("route ln");
  print(route.length);
  print(" $routeType Total Safety Score: $totalScore");
  print(" $routeType the count is $count");
  return totalScore; // Return the total score
}

// Function to map percentage to a 0-4 scale
int mapPercentageToRiskLevel(double percentage)
{
  if (percentage <= 20) return 0; // No Risk
  if (percentage <= 40) return 1; // Low Risk
  if (percentage <= 60) return 2; // Medium Risk
  if (percentage <= 80) return 3; // High Risk
  return 4; // Very High Risk
}

// Function to compare the total safety scores of two routes
Future<int> compareRoutesSafety(int totalalternatescore ,int totalprimaryscore) async {
  // Calculate the total safety scores for both routes
  // Compare the scores and return the appropriate message
  if (totalprimaryscore < totalalternatescore) {
    print("Route 1 is safer with a total safety score of $totalprimaryscore compared to Route 2'safety score $totalalternatescore.");
    return totalprimaryscore;
  } else if (totalalternatescore < totalprimaryscore) {
    print("Route 2 is safer with a total safety score of $totalalternatescore compared to Route 1'$totalprimaryscore");
    return totalalternatescore;
  } else {
    print("Both routes have equal safety scores of $totalprimaryscore.");
    return 0;
  }
}

Future<String> getCrimeType(LatLng point) async {
  try {
    double tolerance = 0.001; // Adjust for precision differences
    QuerySnapshot query = await firestore.collection("crime_reports").get();

    for (var doc in query.docs) {
      double docLatitude = double.parse(doc["latitude"].toString());
      double docLongitude = double.parse(doc["longitude"].toString());

      double latDiff = (point.latitude - docLatitude).abs();
      double longDiff = (point.longitude - docLongitude).abs();

      if (latDiff <= tolerance && longDiff <= tolerance) {
        return doc["type"] ?? "Unknown"; // Return crime type
      }
    }

    return "No Crime Data"; // Return if no match
  } catch (e) {
    print("Error fetching crime type for (${point.latitude}, ${point.longitude}): $e");
    return "Error"; // Return error string
  }
}





// Future<double> calculateAverageSafetyScore(List<LatLng> route, String routeType) async {
//   int totalScore = 0;
//   int count = 0;
//
//   for (int i = 1; i < route.length - 1; i++) { // Exclude start and end points
//     LatLng point = route[i];
//
//     Object? severityObj = await getSeverityScore(point); // Get severity
//     int severity = (severityObj as int?) ?? 0; // Cast to int safely
//
//     totalScore += severity;
//     count++;
//   }
//
//   double avgScore = count > 0 ? totalScore / count : 0.0;
//   print("$routeType Route Average Safety Score: $avgScore");
//
//   return avgScore;
// }
