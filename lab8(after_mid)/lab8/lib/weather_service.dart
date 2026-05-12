import 'dart:convert';
import 'package:http/http.dart' as http;
import 'weather_model.dart';

class WeatherService {
  static const String apiKey = '5ec3fff4de6f685c3634ba6fd3c19311';

  // 🔹 Fetch by lat/lon (Challenge 1)
  Future<Weather> fetchWeather(double lat, double lon) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric'
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }

  // 🔹 Fetch by city (Challenge 2)
  Future<Weather> fetchWeatherByCity(String city) async {
    final geoUrl = Uri.parse(
      'https://api.openweathermap.org/geo/1.0/direct?q=$city&limit=1&appid=$apiKey'
    );

    final geoResponse = await http.get(geoUrl);

    if (geoResponse.statusCode == 200) {
      final geoData = jsonDecode(geoResponse.body);

      final lat = geoData[0]['lat'];
      final lon = geoData[0]['lon'];

      return fetchWeather(lat, lon);
    } else {
      throw Exception('City not found');
    }
  }
}