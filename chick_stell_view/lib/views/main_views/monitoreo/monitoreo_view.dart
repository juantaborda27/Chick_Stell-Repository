import 'package:animate_do/animate_do.dart';
import 'package:chick_stell_view/controllers/warehouse_controller.dart';
import 'package:chick_stell_view/views/main_views/monitoreo/widgets/information_galpon.dart';
import 'package:chick_stell_view/views/main_views/monitoreo/widgets/metric_card.dart';
import 'package:chick_stell_view/views/main_views/monitoreo/widgets/search_galpon.dart';
import 'package:chick_stell_view/views/main_views/monitoreo/widgets/ware_house_header.dart';
import 'package:chick_stell_view/views/main_views/monitoreo/widgets/ware_house_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;



class MonitoreoView extends StatelessWidget {

  final WarehouseController controller = Get.put(WarehouseController());
  MonitoreoView({super.key});

  @override
   Widget build(BuildContext context) {
    // Variable reactiva para controlar el estado de carga
    final isLoading = true.obs;
    
    // Simular tiempo de carga
    Future.delayed(const Duration(milliseconds: 1500), () {
      isLoading.value = false;
    });

    return Scaffold(
      body: SafeArea(
        child: Obx(() => isLoading.value 
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
                      // Obx(() => controller.hasWarning.value ? _buildWarningAlert() : SizedBox()),
                      const WarningAlert(),
                      const SizedBox(height: 20),
                      _buildMetricsGrid(),
                    ],
                  ),
                ),
              ),
            )
        ),
      ),
    );
  }
  
  
  // ignore: unused_element
  Widget _buildMetricsGrid() {
  return GridView.count(
    crossAxisCount: 2,
    shrinkWrap: true,
    mainAxisSpacing: 16,
    crossAxisSpacing: 16,
    childAspectRatio: 1.5,
    physics: NeverScrollableScrollPhysics(),
    children: [
      MetricCard(
        icon: Icons.thermostat_outlined,
        iconColor: Colors.orange,
        title: 'Temperatura',
        value: controller.temperature,
        unit: '°C',
        additionalInfo: '+1.2°C',
        limit: 'Límite: 35°C',
        progress: 0.85,
        progressColor: Colors.orange,
      ),
      MetricCard(
        icon: Icons.water_drop_outlined,
        iconColor: Colors.blue,
        title: 'Humedad',
        value: controller.humidity,
        unit: '%',
        additionalInfo: '+3%',
        limit: 'Óptimo: 60-70%',
        progress: 0.65,
        progressColor: Colors.blue,
      ),
      MetricCard(
        icon: Icons.air,
        iconColor: Colors.green,
        title: 'CO₂',
        value: controller.co2Level,
        unit: 'ppm',
        additionalInfo: 'Óptimo',
        limit: 'Límite: 1500 ppm',
        progress: 0.57,
        progressColor: Colors.green,
      ),
      MetricCard(
        icon: Icons.pets_outlined,
        iconColor: Colors.purple,
        title: 'Actividad Aves',
        value: controller.birdActivity,
        unit: '',
        additionalInfo: 'Estable',
        limit: 'Últimas 2h',
        progress: 0.7,
        progressColor: Colors.purple,
      ),
    ],
  );
}



Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo o imagen (opcional)
          FadeIn(
            child: Image.asset(
              'assets/images/logo.png', // Reemplaza con tu ruta de imagen
              width: 120,
              height: 120,
              // Si no tienes una imagen, comenta o elimina este widget
            ),
          ),
          const SizedBox(height: 30),
          
          // Indicador de carga
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF26A69A)),
          ),
          
          const SizedBox(height: 20),
          
          // Texto animado
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
          
          // Texto secundario (opcional)
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

    // Draw horizontal lines
    for (int i = 1; i < 5; i++) {
      double y = i * size.height / 5;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Draw vertical lines
    for (int i = 1; i < 5; i++) {
      double x = i * size.width / 5;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
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
    
    // Draw 5 blades
    for (int i = 0; i < 5; i++) {
      final angle = i * 2 * 3.14159 / 5;
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
