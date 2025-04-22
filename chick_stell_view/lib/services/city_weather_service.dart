

import 'dart:convert';
import 'package:chick_stell_view/models/city_weather.dart';
import 'package:http/http.dart' as http;


class CityWeatherService {
  Future<CityWeather> fetchWeather(String cityName) async {
    final response = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=${cityName}&appid=fcc4f477aa87fdfe93ebb35a141b26c0&units=metric&lang=es',
    ));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return CityWeather.fromJson(data);
    } else {
      throw Exception('Error al obtener el clima');
    }
  }
}
