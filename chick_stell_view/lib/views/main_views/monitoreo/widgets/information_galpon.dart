import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chick_stell_view/controllers/warehouse_controller.dart';
import 'package:animate_do/animate_do.dart'; // Import animate_do package

class InformationGalpon extends StatelessWidget {
  final WarehouseController controller;
  
  const InformationGalpon({super.key, required this.controller});
  
  @override
  Widget build(BuildContext context) {
    // RxBool to control expanded/collapsed state
    final isExpanded = false.obs;
    
    return Obx(() {
      if (controller.galpones.isEmpty) {
        return const Center(child: Text('No hay galpones disponibles'));
      }
      
      final galpon = controller.galpones[controller.selectedWarehouse.value];
      
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE0F2F1),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with toggle functionality
            InkWell(
              onTap: () => isExpanded.toggle(),
              child: Row(
                children: [
                  Text(
                    'Información del Galpón',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00796B),
                    ),
                  ),
                  const Spacer(),
                  Obx(() => AnimatedRotation(
                    turns: isExpanded.value ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: const Color(0xFF00796B),
                    ),
                  )),
                ],
              ),
            ),
            
            // Animated collapsible content
            Obx(() => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isExpanded.value ? null : 0,
              child: ClipRect(
                child: isExpanded.value
                  ? FadeInDown(
                      duration: const Duration(milliseconds: 500),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              //  _infoCard('ID', galpon.id, Icons.tag),
                              _infoCard('Nombre', galpon.nombre, Icons.warehouse),
                              _infoCard('Largo', '${galpon.largo} m', Icons.straighten),
                              _infoCard('Ancho', '${galpon.ancho} m', Icons.width_normal),
                              _infoCard('Ventiladores', '${galpon.ventiladores}', Icons.air),
                              _infoCard('Nebulizadores', '${galpon.nebulizadores}', Icons.grain),
                              _infoCard('Sensores', '${galpon.sensores}', Icons.sensors),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Container(),
              ),
            )),
          ],
        ),
      );
    });
  }
  
  Widget _infoCard(String label, String value, IconData icon) {
    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      delay: const Duration(milliseconds: 150),
      child: Container(
        width: 145,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: const Color(0xFF009688),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF009688),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}