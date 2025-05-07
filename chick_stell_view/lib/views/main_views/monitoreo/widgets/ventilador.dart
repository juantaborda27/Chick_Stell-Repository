import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import 'package:chick_stell_view/controllers/warehouse_controller.dart';
import 'package:chick_stell_view/views/main_views/monitoreo/monitoreo_view.dart';

class Ventilator extends StatefulWidget {
  final WarehouseController controller;

  const Ventilator({super.key, required this.controller});

  @override
  State<Ventilator> createState() => _VentilatorState();
}

class _VentilatorState extends State<Ventilator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15), // Lento por defecto
    )..repeat();

    widget.controller.ventilationActive.listen((isActive) {
      _controller.duration = Duration(seconds: isActive ? 2 : 15);
      _controller.repeat(); // Reinicia la animación con nueva duración
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            boxShadow: [BoxShadow(blurRadius: 10, spreadRadius: 0)],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: CustomPaint(painter: GridPainter()),
              ),
              AnimatedBuilder(
                animation: _controller,
                builder: (_, child) {
                  return Transform.rotate(
                    angle: _controller.value * 2 * math.pi,
                    child: child,
                  );
                },
                child: CustomPaint(
                  size: const Size(120, 120),
                  painter: FanPainter(color: const Color(0xFF26A69A)),
                ),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color(0xFF0F4C3A),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: Obx(() => Icon(
                widget.controller.ventilationActive.value
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outline,
                color: Colors.grey,
              )),
          label: Obx(() => Text(
                widget.controller.ventilationActive.value
                    ? 'Ventilador Activo'
                    : 'Ventilador Inactivo',
                style: const TextStyle(color: Colors.grey),
              )),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade100,
            foregroundColor: Colors.grey,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () => widget.controller.toggleVentilation(),
        ),
      ],
    );
  }
}
