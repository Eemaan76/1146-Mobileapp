import 'dart:convert';
import 'package:http/http.dart' as http;
import 'weather_model.dart';

class WeatherService {

  // Replace with your actual API key
  static const String apiKey = '5ec3fff4de6f685c3634ba6fd3c19311';
  // Using London's coordinates as default for the lab
  static const double lat = 51.5074;
  static const double lon = -0.1278;

  Future<Weather> fetchWeather() async {

    // We add &units=metric to get Celsius instead of Kelvin
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric'
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {

      // Parse the JSON data
      final jsonResponse = jsonDecode(response.body);
      return Weather.fromJson(jsonResponse);

    } else {
      throw Exception('Failed to load weather data');
    }
  }
}