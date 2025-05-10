import 'dart:convert';
import 'package:chick_stell_view/models/city_weather.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

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

  Future<CityWeather> fetchWeatherByCoordinates(double lat, double lon) async {
    final response = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=fcc4f477aa87fdfe93ebb35a141b26c0&units=metric&lang=es',
    ));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return CityWeather.fromJson(data);
    } else {
      throw Exception('Error al obtener el clima por coordenadas');
    }
  }

  Future<Position> detectarUbicacion() async {
    bool servicioHabilitado;
    LocationPermission permiso;

    servicioHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicioHabilitado) {
      throw 'El servicio de ubicación está deshabilitado.';
    }

    permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        throw 'Los permisos de ubicación fueron denegados.';
      }
    }

    if (permiso == LocationPermission.deniedForever) {
      throw 'Los permisos están denegados permanentemente.';
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // Método para obtener longitud y latitud
  Future<Map<String, double>?> getLocation() async {
    try {
      final pos = await detectarUbicacion();
      return {
        'latitude': pos.latitude,
        'longitude': pos.longitude,
      };
    } catch (e) {
      return null;
    }
  }
}
