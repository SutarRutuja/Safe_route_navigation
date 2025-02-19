//code to be used
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/app_features/feedback_screen.dart';
import 'package:flutter_application_2/app_features/precautions_screen.dart';
import 'package:flutter_application_2/app_features/weather_screen.dart';
import 'package:flutter_application_2/maps/emergency_call.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

import '../admin/LoginScreen.dart';
import 'mapscreen.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  TextEditingController _srcController = TextEditingController();
  TextEditingController _destController = TextEditingController();

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AdminLoginScreen()),
          (route) => false,
    );
  }




  List<dynamic> _srcSuggestions = [];
  List<dynamic> _destSuggestions = [];

  double? _srcLatitude;
  double? _srcLongitude;
  double? _destLatitude;
  double? _destLongitude;

  final String _nominatimUrl = "https://nominatim.openstreetmap.org/search";
  final String _reverseGeocodingUrl = "https://nominatim.openstreetmap.org/reverse";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(10.0), // Set height

        child: AppBar(
          title: Text(""),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                      IconButton(
                        icon: Icon(Icons.account_circle_rounded, color: Colors.black),
                        onPressed: () => _logout(context), // Call logout function
                        tooltip: "Logout",
                      ),

                  SizedBox(height: 40),
                  Text(
                    "You are safe with us.",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 40,
                    width:40,
                    child: Image.asset('assets/astra.png', fit: BoxFit.cover),
                  ),

                ],
              ),

              SizedBox(height: 10),
              
              // Source Location
              Card(
                color: Colors.blue[50],
                elevation:1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Optional rounded corners
                  side: BorderSide(
                    color: Colors.grey, // Light border color
                    width: 0.5, // Thin border
                  ),
                ),
                child: Padding(

                  padding: const EdgeInsets.all(9.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 13,

                      ),
                      TextField(
                        controller: _srcController,
                        onChanged: (value) => _fetchSuggestions(value, isSource: true),
                        decoration: InputDecoration(
                          focusColor: Colors.blueGrey,
                          filled: true, // To fill the input field with color
                          fillColor: Colors.white70,
                      
                          //fillColor: Colors.grey,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          labelText: "Source Location",
                      
                          // suffixIcon: IconButton(
                          //   icon: Icon(Icons.my_location),
                          //   onPressed: _setCurrentLocationAsSource,
                          // ),
                        ),
                      ),

                      if (_srcSuggestions.isNotEmpty)
                        _buildSuggestionsList(_srcSuggestions, isSource: true),
                      SizedBox(height: 8),
                      if (_srcLatitude != null && _srcLongitude != null)
                        Text(
                          "Source Coordinates: $_srcLatitude, $_srcLongitude",
                          //change font size to display src cordinates
                          style: TextStyle(fontSize: 0),
                        ),
                      SizedBox(height: 16),

                      // Destination Location
                      TextField(
                        controller: _destController,
                        onChanged: (value) => _fetchSuggestions(value, isSource: false),
                        decoration: InputDecoration(
                          labelText: "Destination Location",
                          focusColor: Colors.blueGrey,
                          filled: true, // To fill the input field with color
                          fillColor: Colors.white70,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      if (_destSuggestions.isNotEmpty)
                        _buildSuggestionsList(_destSuggestions, isSource: false),
                      SizedBox(height: 8),
                      if (_destLatitude != null && _destLongitude != null)
                        Text(
                          //change font size to sisplay  dest coordinates

                          "Destination Coordinates: $_destLatitude, $_destLongitude",
                          style: TextStyle(fontSize: 0),
                        ),
                      SizedBox(height: 8),
                      // ElevatedButton(
                      //   backgroundColor: Colors.greenAccent, // Accent Green Color
                      //   foregroundColor: Colors.white, // Text Color
                      //   onPressed: () {
                      //     // Ensure both source and destination coordinates are available before navigating
                      //     if (_srcLatitude != null && _srcLongitude != null && _destLatitude != null && _destLongitude != null) {
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => MapScreen(
                      //             sourcelang: _srcLatitude!,
                      //             sourcelong: _srcLongitude!,
                      //             destinationlang: _destLatitude!,
                      //             destinationlong: _destLongitude!,
                      //           ),
                      //         ),
                      //       );
                      //     } else {
                      //       // Show an error dialog if coordinates are missing
                      //       _showErrorDialog(
                      //         "Incomplete Data",
                      //         "Please make sure both source and destination locations are selected.",
                      //       );
                      //     }
                      //   },
                      //   child: const Text("Show Routes"),
                      // ),
                      ElevatedButton(
                        onPressed: () {
                          // Ensure both source and destination coordinates are available before navigating
                          if (_srcLatitude != null && _srcLongitude != null && _destLatitude != null && _destLongitude != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapScreen(
                                  sourcelang: _srcLatitude!,
                                  sourcelong: _srcLongitude!,
                                  destinationlang: _destLatitude!,
                                  destinationlong: _destLongitude!,
                                ),
                              ),
                            );
                          } else {
                            // Show an error dialog if coordinates are missing
                            _showErrorDialog(
                              "Incomplete Data",
                              "Please make sure both source and destination locations are selected.",
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 65, 174, 233), // Accent Green Color
                          foregroundColor: Colors.black, // Text Color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Decreased Border Radius
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Adjust padding if needed
                        ),
                        child: const Text("Show Routes"),
                      ),

                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,

              ),

              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // Prevents list from scrolling separately
                children: [
                  _buildFeatureCard(
                    context,
                    icon: Icons.feedback,
                    title: "Feedback",
                    destination:FeedbackScreen(), // Replace with actual screen
                  ),
                  SizedBox(
                    height: 8,

                  ),
                  _buildFeatureCard(
                    context,
                    icon: Icons.person_remove_alt_1_sharp,
                    title: "Precautions",
                    destination: PrecautionScreen(), // Replace with actual screen
                  ),
                  SizedBox(
                    height: 8,

                  ),
                  _buildFeatureCard(
                    context,
                    icon: Icons.cloud,
                    title: "Weather",
                    destination: WeatherScreen(), // Replace with actual screen
                  ),
                  SizedBox(
                    height: 8,

                  ),
                  _buildFeatureCard(
                    context,
                    icon: Icons.call,
                    title: "Emergency",
                    destination: EmergencyCallApp(), // Replace with actual screen
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionsList(List<dynamic> suggestions, {required bool isSource}) {
    return Container(
      height: 150,
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(suggestions[index]['display_name']),
            onTap: () => _onSuggestionTap(suggestions[index], isSource: isSource),
          );
        },
      ),
    );
  }

  Future<void> _fetchSuggestions(String query, {required bool isSource}) async {
    if (query.isEmpty) {
      setState(() {
        if (isSource) {
          _srcSuggestions = [];
        } else {
          _destSuggestions = [];
        }
      });
      return;
    }

    final url = Uri.parse(
        "$_nominatimUrl?q=$query&format=json&addressdetails=1&limit=5");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          if (isSource) {
            _srcSuggestions = json.decode(response.body);
          } else {
            _destSuggestions = json.decode(response.body);
          }
        });
      }
    } catch (e) {
      print("Error fetching suggestions: $e");
    }
  }

  void _onSuggestionTap(dynamic suggestion, {required bool isSource}) {
    final double latitude = double.parse(suggestion['lat']);
    final double longitude = double.parse(suggestion['lon']);
    setState(() {
      if (isSource) {
        _srcLatitude = latitude;
        _srcLongitude = longitude;
        _srcController.text = suggestion['display_name'];
        _srcSuggestions = [];
      } else {
        _destLatitude = latitude;
        _destLongitude = longitude;
        _destController.text = suggestion['display_name'];
        _destSuggestions = [];
      }
    });
  }

  Future<void> _setCurrentLocationAsSource() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return _showErrorDialog("Location Services Disabled",
          "Please enable location services to proceed.");
    }

    // Request location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return _showErrorDialog("Permission Denied",
          "Location permissions are permanently denied. Please enable them in settings.");
    }

    // Get current position
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Reverse geocode the current position to get location name
    final locationName = await _reverseGeocodeLocation(position.latitude, position.longitude);

    setState(() {
      _srcLatitude = position.latitude;
      _srcLongitude = position.longitude;
      _srcController.text = locationName ?? "Unknown Location";
    });
  }

  Future<String?> _reverseGeocodeLocation(double latitude, double longitude) async {
    final url = Uri.parse(
        "$_reverseGeocodingUrl?lat=$latitude&lon=$longitude&format=json");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['display_name'];
      }
    } catch (e) {
      print("Error during reverse geocoding: $e");
    }
    return null;
  }

  Future<void> _showErrorDialog(String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}



// Function to Create Feature Cards
Widget _buildFeatureCard(BuildContext context, {required IconData icon, required String title, required Widget destination}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
    },
    child: Card(
      elevation: 0, // Remove shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1), // Thin grey border
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            // Rounded Sky-Blue Box for Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade100, // Sky blue color
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(icon, size: 28, color: Colors.blueAccent),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}




// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:geolocator/geolocator.dart';
//
// class LocationScreen extends StatefulWidget {
//   @override
//   _LocationScreenState createState() => _LocationScreenState();
// }
//
// class _LocationScreenState extends State<LocationScreen> {
//   TextEditingController _srcController = TextEditingController();
//   TextEditingController _destController = TextEditingController();
//
//   List<dynamic> _srcSuggestions = [];
//   List<dynamic> _destSuggestions = [];
//
//   double? _srcLatitude;
//   double? _srcLongitude;
//   String? _srcLocationName;
//
//   double? _destLatitude;
//   double? _destLongitude;
//
//   final String _nominatimUrl = "https://nominatim.openstreetmap.org/search";
//   final String _reverseGeocodingUrl = "https://nominatim.openstreetmap.org/reverse";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Location Input"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               // Source Location
//               TextField(
//                 controller: _srcController,
//                 onChanged: (value) => _fetchSuggestions(value, isSource: true),
//                 decoration: InputDecoration(
//                   labelText: "Source Location",
//                   border: OutlineInputBorder(),
//                   suffixIcon: IconButton(
//                     icon: Icon(Icons.my_location),
//                     onPressed: _setCurrentLocationAsSource,
//                   ),
//                 ),
//               ),
//               if (_srcSuggestions.isNotEmpty)
//                 _buildSuggestionsList(_srcSuggestions, isSource: true),
//               SizedBox(height: 8),
//               if (_srcLatitude != null && _srcLongitude != null)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Source Coordinates: $_srcLatitude, $_srcLongitude",
//                       style: TextStyle(fontSize: 14),
//                     ),
//                     if (_srcLocationName != null)
//                       Text(
//                         "Source Location Name: $_srcLocationName",
//                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                       ),
//                   ],
//                 ),
//               SizedBox(height: 16),
//
//               // Destination Location
//               TextField(
//                 controller: _destController,
//                 onChanged: (value) => _fetchSuggestions(value, isSource: false),
//                 decoration: InputDecoration(
//                   labelText: "Destination Location",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               if (_destSuggestions.isNotEmpty)
//                 _buildSuggestionsList(_destSuggestions, isSource: false),
//               SizedBox(height: 8),
//               if (_destLatitude != null && _destLongitude != null)
//                 Text(
//                   "Destination Coordinates: $_destLatitude, $_destLongitude",
//                   style: TextStyle(fontSize: 14),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSuggestionsList(List<dynamic> suggestions, {required bool isSource}) {
//     return Container(
//       height: 150,
//       child: ListView.builder(
//         itemCount: suggestions.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(suggestions[index]['display_name']),
//             onTap: () => _onSuggestionTap(suggestions[index], isSource: isSource),
//           );
//         },
//       ),
//     );
//   }
//
//   Future<void> _fetchSuggestions(String query, {required bool isSource}) async {
//     if (query.isEmpty) {
//       setState(() {
//         if (isSource) {
//           _srcSuggestions = [];
//         } else {
//           _destSuggestions = [];
//         }
//       });
//       return;
//     }
//
//     final url = Uri.parse(
//         "$_nominatimUrl?q=$query&format=json&addressdetails=1&limit=5");
//
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         setState(() {
//           if (isSource) {
//             _srcSuggestions = json.decode(response.body);
//           } else {
//             _destSuggestions = json.decode(response.body);
//           }
//         });
//       }
//     } catch (e) {
//       print("Error fetching suggestions: $e");
//     }
//   }
//
//   void _onSuggestionTap(dynamic suggestion, {required bool isSource}) {
//     final double latitude = double.parse(suggestion['lat']);
//     final double longitude = double.parse(suggestion['lon']);
//     setState(() {
//       if (isSource) {
//         _srcLatitude = latitude;
//         _srcLongitude = longitude;
//         _srcController.text = suggestion['display_name'];
//         _srcSuggestions = [];
//       } else {
//         _destLatitude = latitude;
//         _destLongitude = longitude;
//         _destController.text = suggestion['display_name'];
//         _destSuggestions = [];
//       }
//     });
//   }
//
//   Future<void> _setCurrentLocationAsSource() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return _showErrorDialog("Location Services Disabled",
//           "Please enable location services to proceed.");
//     }
//
//     // Request location permission
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return;
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       return _showErrorDialog("Permission Denied",
//           "Location permissions are permanently denied. Please enable them in settings.");
//     }
//
//     // Get current position
//     final position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//
//     _reverseGeocodeLocation(position.latitude, position.longitude);
//
//     setState(() {
//       _srcLatitude = position.latitude;
//       _srcLongitude = position.longitude;
//       _srcController.text = "Current Location";
//     });
//   }
//
//   Future<void> _reverseGeocodeLocation(double latitude, double longitude) async {
//     final url = Uri.parse(
//         "$_reverseGeocodingUrl?lat=$latitude&lon=$longitude&format=json");
//
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           _srcLocationName = data['display_name'];
//         });
//       }
//     } catch (e) {
//       print("Error during reverse geocoding: $e");
//     }
//   }
//
//   Future<void> _showErrorDialog(String title, String message) async {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(title),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:geolocator/geolocator.dart';
//
// import 'mapscreen.dart';
//
// class LocationScreen extends StatefulWidget {
//   @override
//   _LocationScreenState createState() => _LocationScreenState();
// }
//
// class _LocationScreenState extends State<LocationScreen> {
//   TextEditingController _srcController = TextEditingController();
//   TextEditingController _destController = TextEditingController();
//
//   List<dynamic> _srcSuggestions = [];
//   List<dynamic> _destSuggestions = [];
//
//   double? _srcLatitude;
//   double? _srcLongitude;
//
//   double? _destLatitude;
//   double? _destLongitude;
//
//   final String _nominatimUrl = "https://nominatim.openstreetmap.org/search";
//   final String _reverseGeocodingUrl = "https://nominatim.openstreetmap.org/reverse";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Location Input"),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Location",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//
//             // Source Location Input
//             _buildLocationField(
//               controller: _srcController,
//               hint: "Your Location",
//               onIconPressed: _setCurrentLocationAsSource,
//             ),
//             const SizedBox(height: 12),
//
//             // Destination Location Input
//             _buildLocationField(
//               controller: _destController,
//               hint: "Destination",
//             ),
//             const SizedBox(height: 20),
//
//             // Options (Safest, Shortest)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _buildOptionButton("Safest", true),
//                 _buildOptionButton("Shortest", false),
//               ],
//             ),
//             const SizedBox(height: 16),
//
//             ElevatedButton(
//               onPressed: () {
//                 if (_srcLatitude != null &&
//                     _srcLongitude != null &&
//                     _destLatitude != null &&
//                     _destLongitude != null) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => MapScreen(
//                         sourcelang: _srcLatitude!,
//                         sourcelong: _srcLongitude!,
//                         destinationlang: _destLatitude!,
//                         destinationlong: _destLongitude!,
//                       ),
//                     ),
//                   );
//                 } else {
//                   _showErrorDialog(
//                     "Incomplete Data",
//                     "Please make sure both source and destination locations are selected.",
//                   );
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(50),
//                 backgroundColor: Colors.black,
//               ),
//               child: const Text(
//                 "Show Routes",
//                 style: TextStyle(fontSize: 18, color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLocationField({
//     required TextEditingController controller,
//     required String hint,
//     VoidCallback? onIconPressed,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF0F0F0),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: controller,
//               onChanged: (value) =>
//                   _fetchSuggestions(value, isSource: controller == _srcController),
//               decoration: InputDecoration(
//                 hintText: hint,
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//           if (onIconPressed != null)
//             IconButton(
//               icon: const Icon(Icons.my_location),
//               onPressed: onIconPressed,
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildOptionButton(String label, bool isSelected) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       child: OutlinedButton(
//         onPressed: () {},
//         style: OutlinedButton.styleFrom(
//           backgroundColor: isSelected ? const Color(0xFFFFE5E5) : Colors.white,
//           side: const BorderSide(color: Colors.black),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _fetchSuggestions(String query, {required bool isSource}) async {
//     if (query.isEmpty) {
//       setState(() {
//         if (isSource) {
//           _srcSuggestions = [];
//         } else {
//           _destSuggestions = [];
//         }
//       });
//       return;
//     }
//
//     final url = Uri.parse(
//         "$_nominatimUrl?q=$query&format=json&addressdetails=1&limit=5");
//
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         setState(() {
//           if (isSource) {
//             _srcSuggestions = json.decode(response.body);
//           } else {
//             _destSuggestions = json.decode(response.body);
//           }
//         });
//       }
//     } catch (e) {
//       print("Error fetching suggestions: $e");
//     }
//   }
//
//   Future<void> _setCurrentLocationAsSource() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return _showErrorDialog("Location Services Disabled",
//           "Please enable location services to proceed.");
//     }
//
//     // Request location permission
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return;
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       return _showErrorDialog("Permission Denied",
//           "Location permissions are permanently denied. Please enable them in settings.");
//     }
//
//     // Get current position
//     final position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//
//     // Reverse geocode the current position to get location name
//     final locationName =
//     await _reverseGeocodeLocation(position.latitude, position.longitude);
//
//     setState(() {
//       _srcLatitude = position.latitude;
//       _srcLongitude = position.longitude;
//       _srcController.text = locationName ?? "Unknown Location";
//     });
//   }
//
//   Future<String?> _reverseGeocodeLocation(double latitude, double longitude) async {
//     final url = Uri.parse(
//         "$_reverseGeocodingUrl?lat=$latitude&lon=$longitude&format=json");
//
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return data['display_name'];
//       }
//     } catch (e) {
//       print("Error during reverse geocoding: $e");
//     }
//     return null;
//   }
//
//   Future<void> _showErrorDialog(String title, String message) async {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(title),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
