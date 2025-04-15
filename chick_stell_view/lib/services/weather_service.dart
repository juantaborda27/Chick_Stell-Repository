import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  final String _apiKey = 'b2f93e104fd59845fab30f1eaca58093';
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> getWeatherByCity(String city) async {
    final url = Uri.parse('$_baseUrl?q=$city&appid=$_apiKey&units=metric&lang=es');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('No se pudo obtener el clima de la ciudad.');
    }
  }

  Future<Weather> getWeatherByCoordinates(double lat, double lon) async {
    final url = Uri.parse('$_baseUrl?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&lang=es');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('No se pudo obtener el clima de tu ubicación.');
    }
  }
}
