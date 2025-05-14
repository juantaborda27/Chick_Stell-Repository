import 'dart:convert';
import 'package:chick_stell_view/models/city_weather.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class CityWeatherService {
  static const String _apiKey = 'fcc4f477aa87fdfe93ebb35a141b26c0';

  // Obtener clima actual por nombre de ciudad
  Future<CityWeather> fetchWeather(String cityName) async {
    final response = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$_apiKey&units=metric&lang=es',
    ));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return CityWeather.fromJson(data);
    } else {
      throw Exception('Error al obtener el clima');
    }
  }

  // Obtener clima actual por coordenadas
  Future<CityWeather> fetchWeatherByCoordinates(double lat, double lon) async {
    final response = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&lang=es',
    ));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return CityWeather.fromJson(data);
    } else {
      throw Exception('Error al obtener el clima por coordenadas');
    }
  }

  // Obtener pronóstico diario para los próximos 6 días
  Future<List<Map<String, dynamic>>> fetchForecast(double lat, double lon) async {
    final response = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=minutely,hourly,current,alerts&units=metric&lang=es&appid=$_apiKey',
    ));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List daily = data["daily"];

      return daily.take(6).map<Map<String, dynamic>>((dia) {
        final date = DateTime.fromMillisecondsSinceEpoch(dia["dt"] * 1000, isUtc: true).toLocal();
        return {
          "dia": _obtenerNombreDia(date),
          "max": dia["temp"]["max"].round(),
          "min": dia["temp"]["min"].round(),
          "icon": dia["weather"][0]["icon"], // ejemplo: 10d
          "descripcion": dia["weather"][0]["description"],
        };
      }).toList();
    } else {
      throw Exception('Error al obtener el pronóstico');
    }
  }

  String _obtenerNombreDia(DateTime fecha) {
    const dias = ['DOM', 'LUN', 'MAR', 'MIÉ', 'JUE', 'VIE', 'SÁB'];
    return dias[fecha.weekday % 7];
  }

  // Detectar ubicación actual del dispositivo
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

  // Obtener latitud y longitud
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
