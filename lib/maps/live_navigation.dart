
import 'package:flutter/material.dart';
import 'package:flutter_application_2/maps/timecheck.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../app_features/voice_assistant.dart';
import 'CrimeReport.dart';
import 'CrimeReport2.dart';
import 'emergency_call.dart';

class LiveNavigation extends StatefulWidget {
  final List<LatLng> routeCoordinates;
  final String routeType;
  final LatLng source;
  final LatLng destination;
  final List<String> directions;

  const LiveNavigation({
    Key? key,
    required this.routeCoordinates,
    required this.routeType,
    required this.source,
    required this.destination,
    required this.directions,
  }) : super(key: key);

  @override
  _LiveNavigationState createState() => _LiveNavigationState();
}

class _LiveNavigationState extends State<LiveNavigation> {
  LatLng _currentPosition = LatLng(0, 0);
  late List<LatLng> _routeCoordinates;
  late List<String> _crimeTypes; // List to store safety scores
  //late List<String> _crimeTimes;
  late List<int> _safetyScores;
  late List<String> _crimeTimes;
  final MapController _mapController = MapController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String warningMessage="";
  List<String> timeList = [];
  List<String> arr = ["00:00", "01:00", "02:00", "03:00", "04:00", "05:00", "06:00", "07:00", "08:00", "09:00", "10:00", "11:00",
    "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00", "24:00"];

  @override
  void initState() {
    super.initState();
    _routeCoordinates = widget.routeCoordinates;
    _safetyScores = List.filled(widget.routeCoordinates.length, 0); // Default safety scores
    _getCurrentLocation();
    _startLocationUpdates();
    _fetchSafetyScores();// Fetch safety scores for route

  }

  /// Get current location and update the map
  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
    _mapController.move(_currentPosition, 13.0);
  }

  /// Start real-time location tracking
  void _startLocationUpdates() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    ).listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
      _mapController.move(_currentPosition, 15.0);
    });
  }

  /// Fetch Safety Score from Firestore for each route point
  Future<int> getSeverityScore(LatLng point) async {
    try {
      double tolerance = 0.001;
      QuerySnapshot query = await firestore.collection("crime_reports").get();

      for (var doc in query.docs) {
        double docLatitude = double.parse(doc["latitude"].toString());
        double docLongitude = double.parse(doc["longitude"].toString());

        double latDiff = (point.latitude - docLatitude).abs();
        double longDiff = (point.longitude - docLongitude).abs();

        if (latDiff <= tolerance && longDiff <= tolerance) {
          return doc["severity"] ?? 0;
        }
      }
      return 0; // Default safe score
    } catch (e) {
      print("Error fetching severity: $e");
      return 0;
    }
  }

  /// Fetch Safety Scores for all waypoints
  Future<void> _fetchSafetyScores() async {
    for (int i = 1; i < _routeCoordinates.length - 1; i++) {
      int severity = await getSeverityScore(_routeCoordinates[i]);
      setState(() {
        _safetyScores[i] = severity; // Store safety score
      });
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

  Future<void> _fetchCrimeTypes() async {
    for (int i = 1; i < _routeCoordinates.length - 1; i++) {
      String crimeType = await getCrimeType(_routeCoordinates[i]); // Fetch crime type
      setState(() {
        _crimeTypes[i] = crimeType; // Store crime type
      });
    }
  }

  //crime time


  Future<String> getCrimeTime(LatLng point) async {
    try {
      double tolerance = 0.001; // Adjust for precision differences
      QuerySnapshot query = await firestore.collection("crime_reports").get();

      for (var doc in query.docs) {
        double docLatitude = double.parse(doc["latitude"].toString());
        double docLongitude = double.parse(doc["longitude"].toString());
        String warningMessage = "Tap the button to analyze crime times.";

        double latDiff = (point.latitude - docLatitude).abs();
        double longDiff = (point.longitude - docLongitude).abs();

        if (latDiff <= tolerance && longDiff <= tolerance) {
          return doc["time"] ?? "Unknown"; // Fetch crime time
        }
      }

      return "No Crime Data"; // Default if no match
    } catch (e) {
      print("Error fetching crime time for (${point.latitude}, ${point.longitude}): $e");
      return "Error"; // Return error string
    }
  }

   // Add this at the top

  Future<void> _fetchCrimeTimes() async {
    for (int i = 1; i < _routeCoordinates.length - 1; i++) {
      String crimeTime = await getCrimeTime(_routeCoordinates[i]); // Fetch crime time
      setState(() {
        _crimeTimes[i] = crimeTime; // Store crime time
      });
    }
  }

  // Add this at the top

  Future<void> fetchCrimeTimes() async {
    for (int i = 1; i < _routeCoordinates.length - 1; i++) {
      String crimeTime = await getCrimeTime(_routeCoordinates[i]); // Fetch crime time
      setState(() {
        _crimeTimes[i] = crimeTime; // Store crime time
      });
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ///  Background Map**
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: widget.source,
                zoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routeCoordinates,
                      color: Colors.blue,
                      strokeWidth: 4.0,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentPosition,
                      width: 50.0,
                      height: 50.0,
                      builder: (context) => const Icon(
                        Icons.location_history,
                        color: Colors.blue,
                        size: 40.0,
                      ),
                    ),
                    Marker(
                      point: widget.source,
                      width: 50.0,
                      height: 50.0,
                      builder: (context) => const Icon(
                        Icons.location_pin,
                        color: Colors.black,
                        size: 40.0,
                      ),
                    ),
                    Marker(
                      point: widget.destination,
                      width: 50.0,
                      height: 50.0,
                      builder: (context) => const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// **📜 Draggable Directions Container with Safety Scores**
          DraggableScrollableSheet(
            initialChildSize: 0.2,
            minChildSize: 0.1,
            maxChildSize: 0.5,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Directions",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: widget.directions.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(Icons.girl_outlined),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text(widget.directions[index])),
                                Text(
                                  "Risk: ${_safetyScores[index]}", // Display safety score
                                  style: TextStyle(
                                    color: _safetyScores[index] > 2 ? Colors.red : Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),



      /// **⚡ Floating Buttons**
      floatingActionButton: Positioned(
        top: 100, // Adjust this to move it further down if needed
        right: 10,
        bottom: 70,

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              onPressed: _getCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: makeEmergencyCall,
              child: Container(
                width: 50,
                height: 50,

                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.sos_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),





            FloatingActionButton(
              backgroundColor: Colors.blue[50],
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TextToSpeechScreen(directions: widget.directions),
                  ),
                );
              },
              child: Icon(Icons.mic),
            ),
            SizedBox(
                height:20

            ),



            FloatingActionButton(
              backgroundColor: Colors.teal,
              onPressed: () async {
                List<String> crimeList = [];

                for (int i = 1; i < _routeCoordinates.length - 1; i++) {
                  String crimeType = await getCrimeType(_routeCoordinates[i]);
                  if (crimeType != "No Crime Data") {
                    crimeList.add("Crime at Point ${i + 1}: $crimeType");
                  }
                }

                List<String> timeList = [];

                for (int i = 1; i < _routeCoordinates.length - 1; i++) {
                  String crimeTime = await getCrimeType(_routeCoordinates[i]);
                  if (crimeTime != "No Crime Data") {
                    crimeList.add("Crime at Point ${i + 1}: $crimeTime");
                  }
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CrimeReportPage(crimeList: crimeList,
                       ),
                  ),
                );
              },
              child: Icon(Icons.receipt,
              color: Colors.white,),
            ),
            SizedBox(
                height:20

            ),

            FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () async {
                //List<String> timeList = [];

                for (int i = 1; i < _routeCoordinates.length - 1; i++) {
                  String crimeTime = await getCrimeTime(_routeCoordinates[i]);
                  if (crimeTime != "No Crime Data") {
                    timeList.add("Crime at Point ${i + 1}: Time - $crimeTime");
                  }
                }


                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CrimeReportPage2(crimeList: timeList),
                  ),
                );
              },
              child: Icon(Icons.timeline),
            ),
            SizedBox(
                height:400

            ),
          ],
        ),
      ),
    );
  }
}