import 'package:chick_stell_view/views/main_views/monitoreo/editing_galpon/view_editing_galpon.dart';
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
            borderRadius: BorderRadius.circular(10),
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
                  if (controller.galpones.isNotEmpty) {
                    final galponSeleccionado = controller.galpones[controller.selectedWarehouse.value];
                    showDialog(
                      context: context,
                      builder: (_) => EditGalpon(galpon: galponSeleccionado),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No hay galpones para editar')),
                    );
                  }
                },
                icon: const Icon(Icons.settings, color: Colors.white),
                tooltip: 'Ajustes',
              ),
            ],
          ),
        ));
  }
}
