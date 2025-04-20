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
                controller.galpones.isNotEmpty
                    ? controller.galpones[controller.selectedWarehouse.value].nombre
                    : 'Sin galpones',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  // print('Abrir ajustes');
                },
                icon: const Icon(Icons.settings, color: Colors.white),
                tooltip: 'Ajustes',
              ),
            ],
          ),
        ));
  }
}
