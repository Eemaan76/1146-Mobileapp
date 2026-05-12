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
  final WeatherService _service = WeatherService();

  late Future<Weather> _weatherFuture;

  final TextEditingController latController = TextEditingController();
  final TextEditingController lonController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _weatherFuture = _service.fetchWeather(51.5074, -0.1278);
  }

  // 🔹 Challenge 1
  void _getWeatherByCoords() {
    final lat = double.tryParse(latController.text) ?? 0;
    final lon = double.tryParse(lonController.text) ?? 0;

    setState(() {
      _weatherFuture = _service.fetchWeather(lat, lon);
    });
  }

  // 🔹 Challenge 2
  void _getWeatherByCity() {
    setState(() {
      _weatherFuture = _service.fetchWeatherByCity(cityController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather App")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 🔹 Latitude / Longitude input
            TextField(
              controller: latController,
              decoration: const InputDecoration(labelText: "Latitude"),
            ),

            TextField(
              controller: lonController,
              decoration: const InputDecoration(labelText: "Longitude"),
            ),

            ElevatedButton(
              onPressed: _getWeatherByCoords,
              child: const Text("Get by Coordinates"),
            ),

            const SizedBox(height: 20),

            // 🔹 City input
            TextField(
              controller: cityController,
              decoration: const InputDecoration(labelText: "City Name"),
            ),

            ElevatedButton(
              onPressed: _getWeatherByCity,
              child: const Text("Search by City"),
            ),

            const SizedBox(height: 30),

            // 🔹 Weather Display
            FutureBuilder<Weather>(
              future: _weatherFuture,
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }

                if (snapshot.hasData) {
                  final weather = snapshot.data!;

                  return Column(
                    children: [
                      Text(
                        weather.cityName,
                        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 10),

                      // 🔹 Challenge 3 (ICON)
                      Image.network(
                        'https://openweathermap.org/img/wn/${weather.icon}@2x.png'
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "${weather.temperature.toStringAsFixed(1)}°C",
                        style: const TextStyle(fontSize: 40),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        weather.description.toUpperCase(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  );
                }

                return const Text("No data");
              },
            ),
          ],
        ),
      ),
    );
  }
}