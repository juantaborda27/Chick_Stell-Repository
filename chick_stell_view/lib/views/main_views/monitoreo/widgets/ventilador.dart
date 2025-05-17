import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import 'package:chick_stell_view/controllers/warehouse_controller.dart';

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
      duration: const Duration(seconds: 15), // Por defecto, lento
    )..repeat(); // AnimationController

    // Escuchar solo el observable válido
    ever(widget.controller.ventilationActive, (_) {
      final isVentilationActive = widget.controller.ventilationActive.value;
      final galpon = widget.controller.galponSeleccionado;

      final isHot =
          galpon?.temperaturaInterna != null && galpon!.temperaturaInterna > 30;

      // Si hay ventilación activa o temperatura alta => rápido
      final shouldSpinFast = isVentilationActive || isHot;

      setState(() {
        _controller.duration = Duration(seconds: shouldSpinFast ? 2 : 15);
        _controller.repeat(); // Reinicia con la nueva duración
      });
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
        // Nombre del galpón seleccionado
        Obx(() {
          final galpon = widget.controller.galponSeleccionado;
          return Text(
            galpon != null
                ? "${galpon.nombre}"
                : "Ningún galpón seleccionado",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          );
        }),
        const SizedBox(height: 10),

        // Ventilador gráfico similar a la imagen
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 1,
              )
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Fondo con cuadrícula
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: CustomPaint(painter: GridPainter()),
              ),
              // Aspas del ventilador (rotativas)
              AnimatedBuilder(
                animation: _controller,
                builder: (_, child) {
                  return Transform.rotate(
                    angle: _controller.value * 2 * math.pi,
                    child: child,
                  );
                },
                child: CustomPaint(
                  size: const Size(140, 140),
                  painter: FanBladePainter(),
                ),
              ),
              // Centro del ventilador
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color(0xFF0F4C3A), // Verde oscuro como en la imagen
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Botón para controlar el ventilador
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () => widget.controller.toggleVentilation(),
        ),
      ],
    );
  }
}

// Pintor para la cuadrícula de fondo
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2;

    // Dibuja líneas horizontales
    canvas.drawLine(
      Offset(centerX - radius, centerY),
      Offset(centerX + radius, centerY),
      paint,
    );

    // Dibuja líneas verticales
    canvas.drawLine(
      Offset(centerX, centerY - radius),
      Offset(centerX, centerY + radius),
      paint,
    );

    // Dibuja líneas diagonales
    const double diagonalFactor = 0.7; // Factor para ajustar el largo de las diagonales
    
    canvas.drawLine(
      Offset(centerX - radius * diagonalFactor, centerY - radius * diagonalFactor),
      Offset(centerX + radius * diagonalFactor, centerY + radius * diagonalFactor),
      paint,
    );
    
    canvas.drawLine(
      Offset(centerX - radius * diagonalFactor, centerY + radius * diagonalFactor),
      Offset(centerX + radius * diagonalFactor, centerY - radius * diagonalFactor),
      paint,
    );

    // Dibuja círculo exterior
    canvas.drawCircle(
      Offset(centerX, centerY),
      radius - 1, // Reduce ligeramente para que quede dentro del contenedor
      paint,
    );
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) => false;
}

// Pintor para las aspas del ventilador
class FanBladePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Color turquesa similar al de la imagen
    final bladePaint = Paint()
      ..color = Color(0xFF26A69A)
      ..style = PaintingStyle.fill;
    
    // Dibuja 6 aspas como en la imagen
    for (int i = 0; i < 6; i++) {
      canvas.save();
      // Rota para dibujar cada aspa
      canvas.translate(center.dx, center.dy);
      canvas.rotate(i * math.pi / 3);
      canvas.translate(-center.dx, -center.dy);
      
      // Dibuja una aspa estilizada similar a la imagen
      final path = Path();
      
      // Punto base cerca del centro
      path.moveTo(center.dx - 5, center.dy);
      
      // Curva hacia fuera (aspa más ancha en el medio)
      path.quadraticBezierTo(
        center.dx + radius * 0.3, center.dy - radius * 0.15,
        center.dx + radius * 0.6, center.dy - radius * 0.08
      );
      
      // Punta del aspa
      path.lineTo(center.dx + radius * 0.7, center.dy);
      
      // Curva de regreso
      path.quadraticBezierTo(
        center.dx + radius * 0.3, center.dy + radius * 0.15,
        center.dx - 5, center.dy
      );
      
      path.close();
      canvas.drawPath(path, bladePaint);
      
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(FanBladePainter oldDelegate) => false;
}