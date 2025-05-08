import 'package:chick_stell_view/controllers/city_weather_controller.dart';
import 'package:chick_stell_view/models/city_weather.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClimaView extends StatelessWidget {
  final CityWeatherController controller = Get.put(CityWeatherController());
  final TextEditingController searchController = TextEditingController();

  ClimaView({super.key});

  @override
  Widget build(BuildContext context) {
    // Llama a fetchWeather solo una vez después de que el widget se construya
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getWeather('Manaure');
    });

    return Scaffold(
      body: Column(
        children: [
          // Buscador de ciudades
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar ciudad...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (searchController.text.isNotEmpty) {
                      controller.getWeather(searchController.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Icon(Icons.search),
                ),
              ],
            ),
          ),
          
          // Contenido principal
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.error.value.isNotEmpty) {
                return Center(
                  child: Column(
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
                  ),
                );
              } else if (controller.weatherData.value != null) {
                final data = controller.weatherData.value!;
                return _buildWeatherContent(data, context);
              } else {
                return const Center(child: Text('No hay datos disponibles'));
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherContent(CityWeather data, BuildContext context) {
    String iconUrl = "https://openweathermap.org/img/wn/${data.icon}@2x.png";
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header con ciudad y país
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${data.cityName}, ${data.country}',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          
          // Coordenadas
          Text(
            'Coordenadas: ${data.lat.toStringAsFixed(2)}°, ${data.lon.toStringAsFixed(2)}°',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          
          // Icono y temperatura actual
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                iconUrl,
                width: 80,
                height: 80,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported, size: 80),
              ),
              Text(
                '${data.temperature.toStringAsFixed(1)}°C',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          
          // Descripción
          Text(
            data.description,
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          
          // Tarjetas con información detallada
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'DETALLES',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  
                  // Filas con información detallada
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDetailItem(
                        Icons.thermostat, 
                        'Máxima', 
                        '${data.temMax.toStringAsFixed(1)}°C'
                      ),
                      _buildDetailItem(
                        Icons.ac_unit, 
                        'Mínima', 
                        '${data.temMin.toStringAsFixed(1)}°C'
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDetailItem(
                        Icons.compress, 
                        'Presión', 
                        '${data.pressure.toStringAsFixed(0)} hPa'
                      ),
                      _buildDetailItem(
                        Icons.water_drop, 
                        'Humedad', 
                        '${data.humidity.toStringAsFixed(0)}%'
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Botón para actualizar
          ElevatedButton.icon(
            onPressed: () {
              controller.getWeather(data.cityName);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF26A69A),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            icon: const Icon(Icons.refresh),
            label: const Text('Actualizar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 28, color: const Color(0xFF26A69A)),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}