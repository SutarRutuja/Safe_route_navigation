import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



/// A stateful widget that represents the weather screen.
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // Replace with your actual OpenWeatherMap API key.
  final String apiKey = "9c3524152ffd06c9d6bf5b2a9366f8f5";
  String cityName = "London";
  double? temperature;
  String description = "";
  String icon = "";
  bool isLoading = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch weather data for the default city.
    fetchWeather();
  }

  /// Fetches weather data from OpenWeatherMap for the current [cityName].
  Future<void> fetchWeather() async {
    setState(() {
      isLoading = true;
    });

    // Build the API URL; units=metric returns temperature in Celsius.
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Decode the JSON data.
        final data = jsonDecode(response.body);
        setState(() {
          temperature = data['main']['temp']?.toDouble();
          description = data['weather'][0]['description'];
          icon = data['weather'][0]['icon'];
        });
      } else {
        // Handle error responses.
        _showError("City not found or an error occurred.");
      }
    } catch (e) {
      _showError("Error fetching weather data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Displays a simple error dialog.
  void _showError(String message) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  /// Builds the weather information widget.
  Widget buildWeatherInfo() {
    if (isLoading) {
      return const CircularProgressIndicator();
    } else if (temperature == null) {
      return const Text(
        "No data",
        style: TextStyle(fontSize: 24, color: Colors.white),
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Weather icon
          Image.network(
            "https://openweathermap.org/img/wn/$icon@2x.png",
            width: 100,
            height: 100,
            errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.error, size: 100, color: Colors.white),
          ),
          const SizedBox(height: 10),
          // Temperature
          Text(
            "${temperature!.toStringAsFixed(1)}°C",
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          // Description
          Text(
            description,
            style: const TextStyle(fontSize: 20, color: Colors.white, letterSpacing: 1),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a full-screen gradient background.
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF74ABE2), Color(0xFF5563DE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Display the current city name.
                Text(
                  cityName,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 10),
                // Weather information widget.
                buildWeatherInfo(),
                const SizedBox(height: 20),
                // Input row to search for a different city.
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Enter city",
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          setState(() {
                            cityName = _controller.text;
                          });
                          fetchWeather();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5563DE),
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      ),
                      child: const Text("Go"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
