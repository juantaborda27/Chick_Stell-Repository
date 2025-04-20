import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chick_stell_view/controllers/warehouse_controller.dart';

class WarehouseHeader extends StatelessWidget {
  final WarehouseController controller;

  const WarehouseHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF0F4C3A),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Text(
                'Galpón ${controller.selectedWarehouse.value}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                // child: Text(
                //   controller.ventilationActive.value
                //       ? 'Ventilación activa'
                //       : 'Ventilación inactiva',
                //   style: const TextStyle(color: Colors.white, fontSize: 12),
                // ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  // print('Abrir ajustes');
                },
                icon: const Icon(Icons.settings, color: Colors.white),
                tooltip: 'Ajustes',
              ),
              // const Icon(Icons.thermostat_outlined, color: Colors.amber),
              // const SizedBox(width: 4),
              // const Text('27.2°C', style: TextStyle(color: Colors.white)),
              // const SizedBox(width: 10),
              // Icon(Icons.water_drop_outlined, color: Colors.blue.shade200),
              // const SizedBox(width: 4),
              // const Text('66%', style: TextStyle(color: Colors.white)),
            ],
          ),
        ));
  }
}
