import 'package:chick_stell_view/controllers/warehouse_controller.dart';
import 'package:chick_stell_view/views/main_views/monitoreo/monitoreo_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Ventilator extends StatelessWidget {
  final WarehouseController controller;

  const Ventilator({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Obx(() => Stack(
                alignment: Alignment.center,
                children: [
                  // Fondo de grilla
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: CustomPaint(
                      painter: GridPainter(),
                    ),
                  ),
                  // Aspas del ventilador
                  AnimatedRotation(
                    turns: controller.ventilationActive.value ? 1.0 : 0,
                    duration: const Duration(seconds: 3),
                    child: CustomPaint(
                      size: const Size(120, 120),
                      painter: FanPainter(color: const Color(0xFF26A69A)),
                    ),
                  ),
                  // Centro del ventilador
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0F4C3A),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              )),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: Obx(() => Icon(
                controller.ventilationActive.value
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outline,
                color: Colors.grey,
              )),
          label: Obx(() => Text(
                controller.ventilationActive.value
                    ? 'Ventilador Activo'
                    : 'Ventilador Inactivo',
                style: const TextStyle(color: Colors.grey),
              )),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade100,
            foregroundColor: Colors.grey,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => controller.toggleVentilation(),
        ),
      ],
    );
  }
}
