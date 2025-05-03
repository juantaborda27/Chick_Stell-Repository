import 'package:chick_stell_view/controllers/warehouse_controller.dart';
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
  MonitoreoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SearchGalpon(controller: controller),
                SizedBox(height: 6),
                WarehouseSelector(controller: controller),
                SizedBox(height: 16),
                WarehouseHeader(controller: controller),
                SizedBox(height: 10),
                InformationGalpon(controller: controller),
                SizedBox(height: 20),
                Ventilator(controller: controller),
                SizedBox(height: 20),
                // Obx(() => controller.hasWarning.value ? _buildWarningAlert() : SizedBox()),
                const WarningAlert(),
                SizedBox(height: 20),
                _buildMetricsGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  
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
