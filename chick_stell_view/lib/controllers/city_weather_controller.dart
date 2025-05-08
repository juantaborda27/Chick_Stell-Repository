import 'package:chick_stell_view/models/city_weather.dart';
import 'package:chick_stell_view/services/city_weather_service.dart';
import 'package:get/get.dart';

class CityWeatherController extends GetxController {
  final CityWeatherService weatherService = CityWeatherService();
  var weatherData = Rxn<CityWeather>();
  Rx<CityWeather?> weather = Rx<CityWeather?>(null);
  RxBool isLoading = true.obs;
  RxString error = ''.obs;

  Future<void> getWeather(String city) async {
    isLoading.value = true;
    error.value = '';
    try {
      final data = await weatherService.fetchWeather(city);
      weatherData.value = data;
    } catch (e) {
      error.value = 'No se pudo obtener el clima';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getWeatherByCoordinates(double lat, double lon) async {
    isLoading.value = true;
    error.value = '';
    try {
      final data =
          await CityWeatherService().fetchWeatherByCoordinates(lat, lon);
      weatherData.value = data;
    } catch (e) {
      error.value = 'Error obteniendo el clima: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
