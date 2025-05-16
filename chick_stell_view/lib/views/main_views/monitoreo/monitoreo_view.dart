import 'package:animate_do/animate_do.dart';
import 'package:chick_stell_view/controllers/alerta_controller.dart';
import 'package:chick_stell_view/controllers/simulacion_controller.dart';
import 'package:chick_stell_view/controllers/warehouse_controller.dart';
import 'package:chick_stell_view/models/galpon_model.dart';
import 'package:chick_stell_view/views/main_views/monitoreo/widgets/alert_view.dart';
import 'package:chick_stell_view/views/main_views/monitoreo/widgets/information_galpon.dart';
import 'package:chick_stell_view/views/main_views/monitoreo/widgets/metric_card.dart';
import 'package:chick_stell_view/views/main_views/monitoreo/widgets/search_galpon.dart';
import 'package:chick_stell_view/views/main_views/monitoreo/widgets/ventilador.dart';
import 'package:chick_stell_view/views/main_views/monitoreo/widgets/ware_house_header.dart';
import 'package:chick_stell_view/views/main_views/monitoreo/widgets/ware_house_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class MonitoreoView extends StatelessWidget {
  final WarehouseController controller = Get.put(WarehouseController());
  final SimulacionController simulacionController = Get.put(SimulacionController());

  MonitoreoView({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = true.obs;

    Future.delayed(const Duration(milliseconds: 1500), () {
      isLoading.value = false;
    });

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (simulacionController.galpones.isEmpty) {
            return isLoading.value
                ? _buildLoadingScreen()
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "No hay galpones disponibles.",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            // Cambia la ruta según tu configuración
                            onPressed: () => Get.toNamed('/create_galpon'), //Navigator.of(context).pushNamed('/create_galpon'),
                            // Reemplaza con la ruta de tu vista de creación de galpón 
                            icon: const Icon(Icons.add),
                            label: const Text("Añadir Galpón"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF26A69A),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
          }

          final selectedWarehouseIndex = controller.selectedWarehouse.value;
          final galponSeleccionado = simulacionController.galpones[selectedWarehouseIndex];

          return isLoading.value
              ? _buildLoadingScreen()
              : FadeIn(
                  duration: const Duration(milliseconds: 600),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          SearchGalpon(controller: controller),
                          const SizedBox(height: 6),
                          WarehouseSelector(controller: controller),
                          const SizedBox(height: 16),
                          WarehouseHeader(controller: controller),
                          const SizedBox(height: 10),
                          InformationGalpon(controller: controller),
                          const SizedBox(height: 20),
                          Ventilator(controller: controller),
                          const SizedBox(height: 20),
                          _buildMetricsGrid(galponSeleccionado),
                        ],
                      ),
                    ),
                  ),
                );
        }),
      ),
    );
  }

  Widget _buildMetricsGrid(Galpon galponSeleccionado) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        MetricCard(
          icon: Icons.thermostat_outlined,
          iconColor: Colors.orange,
          title: 'Temperatura',
          value: RxString(galponSeleccionado.temperaturaInterna.toStringAsFixed(2)),
          unit: '°C',
          additionalInfo: '+1.2°C',
          limit: 'Límite: 35°C',
          progress: (galponSeleccionado.temperaturaInterna / 35).obs,
          progressColor: Colors.orange,
        ),
        MetricCard(
          icon: Icons.water_drop_outlined,
          iconColor: Colors.blue,
          title: 'Humedad',
          value: RxString(galponSeleccionado.humedadInterna.toStringAsFixed(2)),
          unit: '%',
          additionalInfo: '+3%',
          limit: 'Óptimo: 60-70%',
          progress: (galponSeleccionado.humedadInterna / 100).obs,
          progressColor: Colors.blue,
        ),
        MetricCard(
          icon: Icons.air,
          iconColor: Colors.green,
          title: 'Velocidad Aire',
          value: RxString(galponSeleccionado.velocidadAire.toStringAsFixed(2)),
          unit: 'm/s',
          additionalInfo: 'Óptimo',
          limit: 'Límite: 3.5 m/s',
          progress: (galponSeleccionado.velocidadAire / 5).obs,
          progressColor: galponSeleccionado.velocidadAire > 3.0
              ? Colors.red
              : Colors.green,
        ),
        MetricCard(
          icon: Icons.pets_outlined,
          iconColor: Colors.purple,
          title: 'Densidad',
          value: RxString(galponSeleccionado.densidadPollos.toStringAsFixed(2)),
          unit: 'm²',
          additionalInfo: 'Óptimo',
          limit: 'Máx: 12 aves/m²',
          progress: (galponSeleccionado.densidadPollos / 20).obs,
          progressColor: galponSeleccionado.densidadPollos > 16
              ? Colors.red
              : Colors.purple,
        ),
      ],
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeIn(
            child: Image.asset(
              'assets/images/logo.png',
              width: 120,
              height: 120,
            ),
          ),
          const SizedBox(height: 30),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF26A69A)),
          ),
          const SizedBox(height: 20),
          FadeInUp(
            from: 20,
            delay: const Duration(milliseconds: 300),
            duration: const Duration(milliseconds: 500),
            child: const Text(
              'Cargando tus galpones...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF26A69A),
              ),
            ),
          ),
          const SizedBox(height: 10),
          FadeInUp(
            from: 20,
            delay: const Duration(milliseconds: 500),
            duration: const Duration(milliseconds: 500),
            child: const Text(
              'Preparando la información',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    for (int i = 1; i < 5; i++) {
      double y = i * size.height / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    for (int i = 1; i < 5; i++) {
      double x = i * size.width / 5;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FanPainter extends CustomPainter {
  final Color color;

  FanPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (int i = 0; i < 5; i++) {
      final angle = i * 2 * math.pi / 5;
      final path = Path();
      path.moveTo(center.dx, center.dy);
      path.lineTo(
        center.dx + radius * 0.2 * cos(angle - 0.3),
        center.dy + radius * 0.2 * sin(angle - 0.3),
      );
      path.lineTo(
        center.dx + radius * 0.9 * cos(angle),
        center.dy + radius * 0.9 * sin(angle),
      );
      path.lineTo(
        center.dx + radius * 0.2 * cos(angle + 0.3),
        center.dy + radius * 0.2 * sin(angle + 0.3),
      );
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

double sin(double x) => math.sin(x);
double cos(double x) => math.cos(x);
