import 'dart:convert';
import 'package:chick_stell_view/models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherController {
  final String apiKey = 'b2f93e104fd59845fab30f1eaca58093';

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Los servicios de ubicación están deshabilitados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permiso de ubicación denegado.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permisos de ubicación permanentemente denegados.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<Weather> fetchWeatherByCity(String city) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=es';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener el clima para la ciudad.');
    }
  }

  Future<Weather> fetchWeatherByLocation() async {
    final position = await _determinePosition();
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric&lang=es';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener el clima para tu ubicación.');
    }
  }
}


