import 'package:chick_stell_view/controllers/city_weather_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClimaView extends StatelessWidget {
  final CityWeatherController controller = Get.put(CityWeatherController());

  ClimaView({super.key});

  @override
  Widget build(BuildContext context) {
    // Llama a fetchWeather solo una vez después de que el widget se construya
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getWeather('Barranquilla'); // O cambia la ciudad que quieras buscar
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima'),
        backgroundColor: const Color(0xFF26A69A),
      ),
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const CircularProgressIndicator();
          } else if (controller.error.value.isNotEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 40),
                const SizedBox(height: 10),
                Text(
                  controller.error.value,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          } else if (controller.weatherData.value != null) {
            final data = controller.weatherData.value!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ciudad: ${data.cityName}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Temperatura: ${data.temperature.toStringAsFixed(1)}°C',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  'Condición: ${data.description}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            );
          } else {
            return const Text('No hay datos disponibles');
          }
        }),
      ),
    );
  }
}

