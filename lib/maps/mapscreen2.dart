// // WAY POINTS IN  LANG LONG
// import 'package:flutter/material.dart';
// import 'package:flutter_application_2/maps/safetycheck.dart';
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
//   List<LatLng> primaryRoute = [];
//   List<LatLng> alternativeRoute = [];
//   List<String> waypoints = [];
//   List<String> alternativeWaypoints = [];
//   int avgSafeScore1 = 0;
//   int avgSafeScore2=0;
//
//   final String osrmBaseUrl = "https://router.project-osrm.org/route/v1/driving";
//
//   @override
//   void initState() {
//     super.initState();
//     sourceCoords = LatLng(widget.sourcelang, widget.sourcelong);
//     destinationCoords = LatLng(widget.destinationlang, widget.destinationlong);
//     fetchRoutes();
//
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
//           setState(() {
//             final fastestRoute = routes.first;
//
//             primaryRoute = (fastestRoute['geometry']['coordinates'] as List<dynamic>)
//                 .map((coord) => LatLng(coord[1], coord[0]))
//                 .toList();
//
//             waypoints = (fastestRoute['legs'][0]['steps'] as List<dynamic>)
//                 .map((step) => step['name'] as String)
//                 .where((name) => name.isNotEmpty)
//                 .toList();
//           });
//
//           // Parse and print waypoints
//           parseAndPrintWaypoints();
//         await processRoute(primaryRoute, "Primary");
//
//           setState(() async {
//             avgSafeScore1 = await calculateTotalSafetyScore(primaryRoute, "Primary");
//           });
//           print("Route primary Avg Safety Score: $avgSafeScore1");
//
//          // await processRoute(alternativeRoute,'primaryRoute' );
//
//
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
//     if (pickPoint == null) return;
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
//           setState(() {
//             final alternative = routes.first;
//
//             alternativeRoute = (alternative['geometry']['coordinates'] as List<dynamic>)
//                 .map((coord) => LatLng(coord[1], coord[0]))
//                 .toList();
//
//             alternativeWaypoints = (alternative['legs'][0]['steps'] as List<dynamic>)
//                 .map((step) => step['name'] as String)
//                 .where((name) => name.isNotEmpty)
//                 .toList();
//           });
//
//           // Parse and print alternative waypoints
//           parseAndPrintWaypoints();
//           await processRoute(alternativeRoute,'AlternateRoute' );
//           avgSafeScore2 = await calculateTotalSafetyScore(alternativeRoute,'AlternateRoute');
//           print("Route alt Avg Safety Score: $avgSafeScore2");
//
//           int routeComparison = await compareRoutesSafety(avgSafeScore1, avgSafeScore2);
//           print(routeComparison);
//         }
//       } else {
//         print("Failed to fetch alternative route: ${response.body}");
//       }
//     } catch (e) {
//       print("Error: $e");
//     }
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
//     return Scaffold(
//       appBar: AppBar(title: const Text("Map with Directions")),
//       body: Column(
//         children: [
//           if (waypoints.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 "Fastest Route Waypoints:\n${waypoints.join(', ')}\nAverage Safety Score: ${avgSafeScore1}",
//
//                 //"Fastest Route Waypoints:\n${waypoints.join(', ') }",
//                 style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//               ),
//             ),
//           if (alternativeWaypoints.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 "Alternative Route Waypoints:\n${alternativeWaypoints.join(', ')}",
//                 style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//               ),
//             ),
//           Expanded(
//             child: FlutterMap(
//               options: MapOptions(
//                 center: sourceCoords,
//                 zoom: 12.0,
//                 onTap: (tapPosition, latLng) {
//                   setState(() {
//                     pickPoint = latLng;
//                     fetchAlternativeRoute();
//                   });
//                 },
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                 ),
//                 if (primaryRoute.isNotEmpty)
//                   PolylineLayer(
//                     polylines: [
//                       Polyline(
//                         points: primaryRoute,
//                         color: Colors.blue,
//                         strokeWidth: 4.0,
//                       ),
//                     ],
//                   ),
//                 if (alternativeRoute.isNotEmpty)
//                   PolylineLayer(
//                     polylines: [
//                       Polyline(
//                         points: alternativeRoute,
//                         color: Colors.green,
//                         strokeWidth: 2.0,
//                         isDotted: true,
//                       ),
//                     ],
//                   ),
//                 MarkerLayer(
//                   markers: [
//                     Marker(
//                       point: sourceCoords,
//                       width: 50.0,
//                       height: 50.0,
//                       builder: (ctx) => const Icon(
//                         Icons.location_pin,
//                         color: Colors.black,
//                         size: 40.0,
//                       ),
//                     ),
//                     Marker(
//                       point: destinationCoords,
//                       width: 50.0,
//                       height: 50.0,
//                       builder: (ctx) => const Icon(
//                         Icons.location_pin,
//                         color: Colors.red,
//                         size: 40.0,
//                       ),
//                     ),
//                     if (pickPoint != null)
//                       Marker(
//                         point: pickPoint!,
//                         width: 50.0,
//                         height: 50.0,
//                         builder: (ctx) => const Icon(
//                           Icons.add_location,
//                           color: Colors.green,
//                           size: 40.0,
//                         ),
//                       ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//

//code in use below
// import 'package:flutter/material.dart';
// import 'package:flutter_application_2/maps/safetycheck.dart';
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
//
//   List<LatLng> primaryRoute = [];
//   List<LatLng> alternativeRoute = [];
//   List<String> waypoints = [];
//   List<String> alternativeWaypoints = [];
//   int avgSafeScore1 = 0;
//   int avgSafeScore2 = 0;
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
//
//
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
//
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
//
//           });
//
//           // Process the primary route safety
//           await processRoute(primaryRoute, "Primary");
//           int score1 = await calculateTotalSafetyScore(primaryRoute, "Primary");
//           print("Route primary Avg Safety Score: $score1");
//           setState(() {
//
//
//             avgSafeScore1 = score1;
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
//     if (pickPoint == null) return;
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
//           setState(() {
//             avgSafeScore2 = score2;
//           });
//
//           // Compare routes and update the safe route indicator and message
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
//           : Colors.green,
//       strokeWidth: (_safeRouteIndicator == "alternate") ? 6.0 : 2.0,
//       // isDotted: true remains if desired
//       isDotted: true,
//     );
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Map with Directions  " )),
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
//           if (waypoints.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 "Fastest Route Waypoints:\n${waypoints.join(', ')}\nAverage Safety Score: $avgSafeScore1",
//                 style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//               ),
//             ),
//           if (alternativeWaypoints.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 "Alternative Route Waypoints:\n${alternativeWaypoints.join(', ')}\nAverage Safety Score: $avgSafeScore2",
//                 style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//               ),
//             ),
//           //adding here  dsitance and time:
//
//
//           Expanded(
//             child: FlutterMap(
//               options: MapOptions(
//                 center: sourceCoords,
//                 zoom: 12.0,
//                 onTap: (tapPosition, latLng) {
//                   setState(() {
//                     pickPoint = latLng;
//                   });
//                   fetchAlternativeRoute();
//                 },
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                 ),
//                 if (primaryRoute.isNotEmpty)
//                   PolylineLayer(
//                     polylines: [primaryPolyline],
//                   ),
//                 if (alternativeRoute.isNotEmpty)
//                   PolylineLayer(
//                     polylines: [alternatePolyline],
//                   ),
//                 MarkerLayer(
//                   markers: [
//                     Marker(
//                       point: sourceCoords,
//                       width: 50.0,
//                       height: 50.0,
//                       builder: (ctx) => const Icon(
//                         Icons.location_pin,
//                         color: Colors.black,
//                         size: 40.0,
//                       ),
//                     ),
//                     Marker(
//                       point: destinationCoords,
//                       width: 50.0,
//                       height: 50.0,
//                       builder: (ctx) => const Icon(
//                         Icons.location_pin,
//                         color: Colors.red,
//                         size: 40.0,
//                       ),
//                     ),
//                     if (pickPoint != null)
//                       Marker(
//                         point: pickPoint!,
//                         width: 50.0,
//                         height: 50.0,
//                         builder: (ctx) => const Icon(
//                           Icons.add_location,
//                           color: Colors.green,
//                           size: 40.0,
//                         ),
//                       ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
