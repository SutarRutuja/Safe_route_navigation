// import 'package:flutter/material.dart';
// import 'package:flutter_application_2/maps/live_navigation.dart';
// import 'package:flutter_application_2/maps/safetycheck.dart';
// import 'package:flutter_application_2/mycolors.dart'as mycolors;
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../maps/safetycheck.dart';
//
// class MapScreen extends StatefulWidget {
//   final double sourcelang;
//   final double sourcelong;
//   final double destinationlang;
//   final double destinationlong;
//
//   const MapScreen({
//     Key? key,
//     required this.sourcelang,
//     required this.sourcelong,
//     required this.destinationlang,
//     required this.destinationlong,
//   }) : super(key: key);
//
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   late LatLng sourceCoords;
//   late LatLng destinationCoords;
//   LatLng? pickPoint;
//
//   String  distance="";
//   String time="";
//
//
//
//   List<LatLng> primaryRoute = [];
//   List<LatLng> alternativeRoute = [];
//   List<String> waypoints = [];
//   List<String> alternativeWaypoints = [];
//   int avgSafeScore1 = 0;
//   int avgSafeScore2 = 0;
//   List<String>  directions = [];
//
//   // Store which route is the safest: "primary", "alternate", or "equal"
//   String _safeRouteIndicator = "";
//   // A message to show the user
//   String _safeRouteResult = "";
//
//   final String osrmBaseUrl = "https://router.project-osrm.org/route/v1/driving";
//
//   @override
//   void initState() {
//     super.initState();
//     sourceCoords = LatLng(widget.sourcelang, widget.sourcelong);
//     destinationCoords = LatLng(widget.destinationlang, widget.destinationlong);
//     fetchRoutes();
//   }
//
//   Future<void> fetchRoutes() async {
//     try {
//       final url =
//           "$osrmBaseUrl/${sourceCoords.longitude},${sourceCoords.latitude};${destinationCoords.longitude},${destinationCoords.latitude}?overview=full&geometries=geojson&alternatives=false&steps=true";
//
//       final response = await http.get(Uri.parse(url));
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final List<dynamic> routes = data['routes'];
//
//         if (routes.isNotEmpty) {
//           final fastestRoute = routes.first;
//           List<LatLng> fetchedPrimaryRoute = (fastestRoute['geometry']['coordinates'] as List<dynamic>)
//               .map((coord) => LatLng(coord[1], coord[0]))
//               .toList();
//
//           List<String> fetchedWaypoints = (fastestRoute['legs'][0]['steps'] as List<dynamic>)
//               .map((step) => step['name'] as String)
//               .where((name) => name.isNotEmpty)
//               .toList();
//
//           // Update state for primary route and waypoints
//           setState(() {
//             primaryRoute = fetchedPrimaryRoute;
//             waypoints = fetchedWaypoints;
//             for (var step in fastestRoute['legs'][0]['steps']) {
//               String maneuver = step['maneuver']['modifier'] ?? "Continue"; // Turn type
//               String roadName = step['name'].isNotEmpty ? step['name'] : "Unnamed Road";
//               double distance = step['distance']; // Distance in meters
//
//               String directionText = "$maneuver $roadName ${distance.toStringAsFixed(1)}m";
//               directions.add(directionText);
//               waypoints.add(roadName);
//
//               print(directionText); // Debugging: Prints each turn instruction
//             }
//
//
//           });
//
//           // Process the primary route safety
//           await processRoute(primaryRoute, "Primary");
//           int score1 = await calculateTotalSafetyScore(primaryRoute, "Primary");
//           print("Route primary Avg Safety Score: $score1");
//           setState(() {
//
//             avgSafeScore1 = score1;
//
//             // logic for  duration
//             var duration = fastestRoute['legs'][0]['duration']; // Duration in seconds
//             final hours = (duration / 3600).floor(); // Get hours
//             final minutes = ((duration % 3600) / 60).floor(); // Get remaining minutes
//             String formattedDuration;
//             if (hours > 0) {
//               formattedDuration = "$hours hours ${minutes > 0 ? '$minutes minutes' : ''}";
//             } else {
//               formattedDuration = "$minutes minutes";
//             }
//             print("Duration: $formattedDuration");
//
//             //logic for distance
//             var distance = fastestRoute['legs'][0]['distance']; // Distance in meters
//             String formattedDistance;
//             if (distance >= 1000) {
//               formattedDistance = "${(distance / 1000).toStringAsFixed(2)} km"; // Convert to km
//             } else {
//               formattedDistance = "${distance.toStringAsFixed(0)} meters"; // Show in meters
//             }
//             print("Distance: $formattedDistance");
//
//             setState(() {
//               distance=formattedDistance;
//
//             });
//           });
//
//           // Optionally, parse waypoints to print coordinates
//           await parseAndPrintWaypoints();
//         }
//       } else {
//         print("Failed to fetch routes: ${response.body}");
//       }
//     } catch (e) {
//       print("Error: $e");
//     }
//   }
//
//   Future<void> fetchAlternativeRoute() async {
//     if (primaryRoute.isEmpty) return;
//
//     // Get the midpoint of the primary route
//     int midIndex = (primaryRoute.length / 2).floor();
//     LatLng midPoint = primaryRoute[midIndex];
//
//     // Shift the midpoint slightly left (reduce longitude)
//     double shiftDistance = 0.005; // Adjust as needed
//     pickPoint = LatLng(midPoint.latitude, midPoint.longitude - shiftDistance);
//
//     try {
//       final url =
//           "$osrmBaseUrl/${sourceCoords.longitude},${sourceCoords.latitude};${pickPoint!.longitude},${pickPoint!.latitude};${destinationCoords.longitude},${destinationCoords.latitude}?overview=full&geometries=geojson&steps=true";
//
//       final response = await http.get(Uri.parse(url));
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final List<dynamic> routes = data['routes'];
//
//         if (routes.isNotEmpty) {
//           final alternative = routes.first;
//           List<LatLng> fetchedAlternativeRoute = (alternative['geometry']['coordinates'] as List<dynamic>)
//               .map((coord) => LatLng(coord[1], coord[0]))
//               .toList();
//
//           List<String> fetchedAlternativeWaypoints = (alternative['legs'][0]['steps'] as List<dynamic>)
//               .map((step) => step['name'] as String)
//               .where((name) => name.isNotEmpty)
//               .toList();
//
//           // Update state for alternative route and waypoints
//           setState(() {
//             alternativeRoute = fetchedAlternativeRoute;
//             alternativeWaypoints = fetchedAlternativeWaypoints;
//           });
//
//           // Process alternative route safety score
//           await processRoute(alternativeRoute, "AlternateRoute");
//           int score2 = await calculateTotalSafetyScore(alternativeRoute, "AlternateRoute");
//           print("Route alt Avg Safety Score: $score2");
//
//           setState(() {
//             avgSafeScore2 = score2;
//           });
//
//           // Compare routes
//           _compareRoutes();
//         }
//       } else {
//         print("Failed to fetch alternative route: ${response.body}");
//       }
//     } catch (e) {
//       print("Error: $e");
//     }
//   }
//
//
//   // Compare the two safety scores and update a state variable with the result.
//   void _compareRoutes() {
//     String result;
//     String indicator;
//
//     if (avgSafeScore1 < avgSafeScore2) {
//       result = "Primary route is safer with a score of $avgSafeScore1 compared to alternative's $avgSafeScore2.";
//       indicator = "primary";
//     } else if (avgSafeScore2 < avgSafeScore1) {
//       result = "Alternative route is safer with a score of $avgSafeScore2 compared to primary's $avgSafeScore1.";
//       indicator = "alternate";
//     } else {
//       result = "Both routes have equal safety scores of $avgSafeScore1.";
//       indicator = "equal";
//     }
//
//     setState(() {
//       _safeRouteResult = result;
//       _safeRouteIndicator = indicator;
//     });
//     print(result);
//   }
//
//   Future<void> parseAndPrintWaypoints() async {
//     const String nominatimBaseUrl = "https://nominatim.openstreetmap.org/search";
//
//     Future<LatLng?> getCoordinates(String location) async {
//       try {
//         final url = "$nominatimBaseUrl?q=$location&format=json";
//         final response = await http.get(Uri.parse(url));
//
//         if (response.statusCode == 200) {
//           final data = json.decode(response.body) as List<dynamic>;
//           if (data.isNotEmpty) {
//             final double lat = double.parse(data.first['lat']);
//             final double lon = double.parse(data.first['lon']);
//             return LatLng(lat, lon);
//           }
//         }
//       } catch (e) {
//         print("Error fetching coordinates for $location: $e");
//       }
//       return null;
//     }
//
//     for (String waypoint in waypoints) {
//       final coordinates = await getCoordinates(waypoint);
//       if (coordinates != null) {
//         print("Waypoint: $waypoint -> Coordinates: $coordinates");
//       } else {
//         print("Failed to fetch coordinates for waypoint: $waypoint");
//       }
//     }
//
//     for (String altWaypoint in alternativeWaypoints) {
//       final coordinates = await getCoordinates(altWaypoint);
//       if (coordinates != null) {
//         print("Alternative Waypoint: $altWaypoint -> Coordinates: $coordinates");
//       } else {
//         print("Failed to fetch coordinates for alternative waypoint: $altWaypoint");
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Determine polyline styles based on which route is safer.
//     final primaryPolyline = Polyline(
//       points: primaryRoute,
//       color: (_safeRouteIndicator == "primary")
//           ? Colors.lightGreen
//           : Colors.blue,
//       strokeWidth: (_safeRouteIndicator == "primary") ? 6.0 : 4.0,
//     );
//
//     final alternatePolyline = Polyline(
//       points: alternativeRoute,
//       color: (_safeRouteIndicator == "alternate")
//           ? Colors.lightGreen
//           : Colors.black,
//       strokeWidth: (_safeRouteIndicator == "alternate") ? 6.0 : 4.0,
//       // isDotted: true remains if desired
//       isDotted: true,
//     );
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Map with Directions")),
//
//
//       body: Column(
//         children: [
//           if (_safeRouteResult.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 _safeRouteResult,
//                 style: const TextStyle(
//                   fontSize: 16.0,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.lightGreen, // Safe route highlighted in light green
//                 ),
//               ),
//             ),
//
//           Expanded(
//             child: Stack(
//
//               children:[ Positioned.fill(
//
//
//                 child: FlutterMap(
//                   options: MapOptions(
//                     center: sourceCoords,
//                     zoom: 12.0,
//                     onTap: (tapPosition, latLng) {
//                       setState(() {
//                         pickPoint = latLng;
//                       });
//                       fetchAlternativeRoute();
//                     },
//                   ),
//                   children: [
//                     TileLayer(
//                       urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                     ),
//                     if (primaryRoute.isNotEmpty)
//                       PolylineLayer(
//                         polylines: [primaryPolyline],
//                       ),
//                     if (alternativeRoute.isNotEmpty)
//                       PolylineLayer(
//                         polylines: [alternatePolyline],
//                       ),
//                     MarkerLayer(
//                       markers: [
//                         Marker(
//                           point: sourceCoords,
//                           width: 50.0,
//                           height: 50.0,
//                           builder: (ctx) => const Icon(
//                             Icons.location_pin,
//                             color: Colors.black,
//                             size: 40.0,
//                           ),
//                         ),
//                         Marker(
//                           point: destinationCoords,
//                           width: 50.0,
//                           height: 50.0,
//                           builder: (ctx) => const Icon(
//                             Icons.location_pin,
//                             color: Colors.red,
//                             size: 40.0,
//                           ),
//                         ),
//                         if (pickPoint != null)
//                           Marker(
//                             point: pickPoint!,
//                             width: 50.0,
//                             height: 50.0,
//                             builder: (ctx) => const Icon(
//                               Icons.location_pin,
//                               color: Colors.blue,
//                               size: 40.0,
//                             ),
//                           ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//                 Positioned(
//                   bottom: 10, // Adjust based on spacing
//                   left: 15,
//                   right: 15,
//                   child: Container(
//                     height: 160, // Covers both boxes
//                     decoration: BoxDecoration(
//                       color: Colors.white, // White background
//                       borderRadius: BorderRadius.circular(20), // Rounded corners
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12, // Light shadow for depth
//                           blurRadius: 8,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//
//
//
//                 Positioned(
//                   bottom: 22,
//                   left: 30,
//                   right: 30,
//
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Expanded( // First Container (Primary Route Info)
//                         child: Container(
//                           padding: EdgeInsets.all(13),
//                           height: 130,
//                           width: 90,
//                           decoration: BoxDecoration(
//                             // boxShadow: [
//                             //   BoxShadow(
//                             //     offset: Offset(4, 4),
//                             //     blurRadius: 5,
//                             //     color: mycolors.AppColor.gradientSecond.withOpacity(0.2),
//                             //   ),
//                             // ],
//                             border: Border.all(
//                               color: Colors.grey, // Grey color
//                               width: 1.0,         // Thin border
//                             ),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Primary',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w700,
//                                   color: Colors.blueAccent,
//
//
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               Text(
//                                 'Score: $avgSafeScore1',
//                                 style: TextStyle(
//                                   color: Colors.black87,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.start, // Aligning content to the left
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Distance: $distance',
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                   SizedBox(width: 20,
//                                   ),
//
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10), // Rounded container
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: mycolors.AppColor.gradientFirst, // Shadow color
//                                           blurRadius: 100, // Blur effect
//                                           offset: Offset(8, 4), // Shadow position
//                                           // Shadow position
//                                         ),
//                                       ],
//                                     ),
//                                     child: IconButton(
//                                       icon: const Icon(
//                                         Icons.navigation_rounded,
//                                         color: Colors.blue,
//                                         size: 35,
//                                       ),
//                                       onPressed: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) => LiveNavigation(
//                                               routeCoordinates: primaryRoute,
//                                               routeType: "primary",
//                                               source: sourceCoords,
//                                               destination: destinationCoords, directions: directions,
//                                             ),
//                                           ),
//                                         );
//                                         print("Navigating using Primary route");
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Expanded(child: Container()),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 10), // Space between containers
//                       Expanded( // Second Container (Alternate Route Info)
//                         child: Container(
//                           padding: EdgeInsets.all(15),
//                           height: 130,
//                           decoration: BoxDecoration(
//                             boxShadow: [
//                               BoxShadow(
//                                 offset: Offset(4, 4),
//                                 blurRadius: 10,
//                                 color: mycolors.AppColor.gradientSecond.withOpacity(0.2),
//                               ),
//                             ],
//                             gradient: LinearGradient(
//                               colors: [
//                                 mycolors.AppColor.gradientFirst.withOpacity(0.8),
//                                 mycolors.AppColor.gradientSecond.withOpacity(0.9),
//                               ],
//                               begin: Alignment.bottomLeft,
//                               end: Alignment.centerRight,
//                             ),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Alternate',
//                                 style: TextStyle(
//                                   color: mycolors.AppColor.homePageContainerTextSmall,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               Text(
//                                 'Score: $avgSafeScore2',
//                                 style: TextStyle(
//                                   color: mycolors.AppColor.homePageContainerTextSmall,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.start, // Aligning content to the left
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Distance: $distance',
//                                     style: TextStyle(
//                                       color: mycolors.AppColor.homePageContainerTextSmall,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                   SizedBox(width: 30,
//                                   ),
//
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(60), // Rounded container
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: mycolors.AppColor.gradientFirst, // Shadow color
//                                           blurRadius: 50, // Blur effect
//                                           offset: Offset(4, 8), // Shadow position
//                                         ),
//                                       ],
//                                     ),
//                                     child: IconButton(
//                                       icon: const Icon(
//                                         Icons.navigation_rounded,
//                                         color: Colors.white,
//                                         size: 30,
//                                       ),
//                                       onPressed: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) => LiveNavigation(
//                                               routeCoordinates: alternativeRoute,
//                                               routeType: "alternate",
//                                               source: sourceCoords,
//                                               destination: destinationCoords,
//                                               directions: directions,
//                                             ),
//                                           ),
//                                         );
//                                         print("Navigating using Primary route");
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Expanded(child: Container()), // Pushes the play button and timer to the left
//                             ],
//                           ),
//
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // if (waypoints.isNotEmpty)
//           //   Padding(
//           //     padding: const EdgeInsets.all(8.0),
//           //     child:Row(
//           //       mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjust alignment
//           //       children: [
//           //         Expanded(
//           //           child: Container(
//           //             padding: EdgeInsets.only(left: 20, top: 25, right: 20),
//           //             height: 150,
//           //             decoration: BoxDecoration(
//           //               boxShadow: [
//           //                 BoxShadow(
//           //                   offset: Offset(10, 10),
//           //                   blurRadius: 10,
//           //                   color: mycolors.AppColor.gradientSecond.withOpacity(0.2),
//           //                 ),
//           //               ],
//           //               gradient: LinearGradient(
//           //                 colors: [
//           //                   mycolors.AppColor.gradientFirst.withOpacity(0.8),
//           //                   mycolors.AppColor.gradientSecond.withOpacity(0.9),
//           //                 ],
//           //                 begin: Alignment.bottomLeft,
//           //                 end: Alignment.centerRight,
//           //               ),
//           //               borderRadius: BorderRadius.only(
//           //                 topLeft: Radius.circular(20),
//           //                 bottomRight: Radius.circular(20),
//           //                 bottomLeft: Radius.circular(20),
//           //                 topRight: Radius.circular(20),
//           //               ),
//           //             ),
//           //             child: Column(
//           //               crossAxisAlignment: CrossAxisAlignment.start,
//           //               children: [
//           //                 Text(
//           //                   'Primary',
//           //                   style: TextStyle(
//           //                     color: mycolors.AppColor.homePageContainerTextSmall,
//           //                     fontSize: 16,
//           //                   ),
//           //                 ),
//           //                 SizedBox(height: 3),
//           //                 Text(
//           //                   'Score: $avgSafeScore1',
//           //                   style: TextStyle(
//           //                     color: mycolors.AppColor.homePageContainerTextSmall,
//           //                     fontSize: 16,
//           //                   ),
//           //                 ),
//           //                 Text(
//           //                   'Distance: $distance',
//           //                   style: TextStyle(
//           //                     color: mycolors.AppColor.homePageContainerTextSmall,
//           //                     fontSize: 16,
//           //                   ),
//           //                 ),
//           //                 Row(
//           //                   crossAxisAlignment: CrossAxisAlignment.end,
//           //                   children: [
//           //                     Row(
//           //                       children: [
//           //                         Icon(
//           //                           Icons.timer_sharp,
//           //                           color: mycolors.AppColor.homePageContainerTextSmall,
//           //                         ),
//           //                         SizedBox(width: 2),
//           //                         Text(
//           //                           '60 min',
//           //                           style: TextStyle(
//           //                             color: mycolors.AppColor.homePageContainerTextSmall,
//           //                             fontSize: 10,
//           //                           ),
//           //                         ),
//           //                       ],
//           //                     ),
//           //                     Expanded(child: Container()),
//           //                     Container(
//           //                       decoration: BoxDecoration(
//           //                         borderRadius: BorderRadius.circular(60),
//           //                         boxShadow: [
//           //                           BoxShadow(
//           //                             color: mycolors.AppColor.gradientFirst,
//           //                             blurRadius: 10,
//           //                             offset: Offset(4, 8),
//           //                           ),
//           //                         ],
//           //                       ),
//           //                       child: Icon(
//           //                         Icons.play_circle_fill,
//           //                         color: Colors.white,
//           //                         size: 40,
//           //                       ),
//           //                     ),
//           //                   ],
//           //                 ),
//           //               ],
//           //             ),
//           //           ),
//           //         ),
//           //
//           //         SizedBox(width: 15), // Spacing between the two containers
//           //
//           //         Expanded(
//           //           child: Container(
//           //             padding: EdgeInsets.only(left: 20, top: 25, right: 20,bottom: 15),
//           //             height: 150,
//           //             decoration: BoxDecoration(
//           //               boxShadow: [
//           //                 BoxShadow(
//           //                   offset: Offset(10, 10),
//           //                   blurRadius: 10,
//           //                   color: mycolors.AppColor.gradientSecond.withOpacity(0.2),
//           //                 ),
//           //               ],
//           //               gradient: LinearGradient(
//           //                 colors: [
//           //                   mycolors.AppColor.gradientFirst.withOpacity(0.8),
//           //                   mycolors.AppColor.gradientSecond.withOpacity(0.9),
//           //                 ],
//           //                 begin: Alignment.bottomLeft,
//           //                 end: Alignment.centerRight,
//           //               ),
//           //               borderRadius: BorderRadius.only(
//           //                 topLeft: Radius.circular(20),
//           //                 bottomRight: Radius.circular(20),
//           //                 bottomLeft: Radius.circular(20),
//           //                 topRight: Radius.circular(20),
//           //               ),
//           //             ),
//           //             child: Column(
//           //               crossAxisAlignment: CrossAxisAlignment.start,
//           //               children: [
//           //                 Text(
//           //                   'Alternate',
//           //                   style: TextStyle(
//           //                     color: mycolors.AppColor.homePageContainerTextSmall,
//           //                     fontSize: 15,
//           //                   ),
//           //                 ),
//           //                 SizedBox(height: 4),
//           //                 Text(
//           //                   'Score: $avgSafeScore2',
//           //                   style: TextStyle(
//           //                     color: mycolors.AppColor.homePageContainerTextSmall,
//           //                     fontSize: 16,
//           //                   ),
//           //                 ),
//           //                 Text(
//           //                   'Distance: $distance',
//           //                   style: TextStyle(
//           //                     color: mycolors.AppColor.homePageContainerTextSmall,
//           //                     fontSize: 15,
//           //                   ),
//           //                 ),
//           //                 Row(
//           //                   crossAxisAlignment: CrossAxisAlignment.end,
//           //                   children: [
//           //                     Row(
//           //                       children: [
//           //                         Icon(
//           //                           Icons.timer_sharp,
//           //                           color: mycolors.AppColor.homePageContainerTextSmall,
//           //                         ),
//           //                         SizedBox(width: 1),
//           //                         Text(
//           //                           '60 min',
//           //                           style: TextStyle(
//           //                             color: mycolors.AppColor.homePageContainerTextSmall,
//           //                             fontSize: 10,
//           //                           ),
//           //                         ),
//           //                       ],
//           //                     ),
//           //                     Expanded(child: Container()),
//           //                     Container(
//           //                       decoration: BoxDecoration(
//           //                         borderRadius: BorderRadius.circular(60),
//           //                         boxShadow: [
//           //                           BoxShadow(
//           //                             color: mycolors.AppColor.gradientFirst,
//           //                             blurRadius: 10,
//           //                             offset: Offset(4, 8),
//           //                           ),
//           //                         ],
//           //                       ),
//           //                       child: Icon(
//           //                         Icons.play_circle_fill,
//           //                         color: Colors.white,
//           //                         size: 40,
//           //                       ),
//           //                     ),
//           //                   ],
//           //                 ),
//           //               ],
//           //             ),
//           //           ),
//           //         ),
//           //       ],
//           //     )
//           //
//           //     // child: Text(
//           //     //   "Fastest Route Waypoints:\n${waypoints.join(', ')}\nAverage Safety Score: $avgSafeScore1",
//           //     //   style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//           //     // ),
//           //   ),
//           // if (alternativeWaypoints.isNotEmpty)
//           //   Padding(
//           //     padding: const EdgeInsets.all(8.0),
//           //     child: Text(
//           //       "Alternative Route Waypoints:\n${alternativeWaypoints.join(', ')}\nAverage Safety Score: $avgSafeScore2",
//           //       style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//           //     ),
//           //   ),
//           //adding here  dsitance and time:
//
//
//
//         ],
//       ),
//     );
//   }
// }
