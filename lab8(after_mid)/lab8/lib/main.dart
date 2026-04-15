import 'package:flutter/material.dart';
import 'weather_model.dart';
import 'weather_service.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Lab',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  late Future<Weather> _weatherFuture;

  @override
  void initState() {
    super.initState();

    // Trigger the API call when the screen loads
    _weatherFuture = _weatherService.fetchWeather();
  }

  // Function to manually refresh data
  void _refreshWeather() {
    setState(() {
      _weatherFuture = _weatherService.fetchWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Weather'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshWeather,
          )
        ],
      ),
      body: Center(
        child: FutureBuilder<Weather>(
          future: _weatherFuture,
          builder: (context, snapshot) {

            // State 1: Still loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            // State 2: Error occurred
            else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            // State 3: Data successfully fetched
            else if (snapshot.hasData) {
              final weather = snapshot.data!;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weather.cityName,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    '${weather.temperature.toStringAsFixed(1)}°C',
                    style: const TextStyle(fontSize: 60),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    weather.description.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.grey,
                    ),
                  ),
                ],
              );
            }

            // Fallback state
            return const Text('No data available');
          },
        ),
      ),
    );
  }
}