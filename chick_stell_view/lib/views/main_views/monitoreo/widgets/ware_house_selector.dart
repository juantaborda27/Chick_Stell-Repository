import 'package:chick_stell_view/controllers/warehouse_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarehouseSelector extends StatelessWidget {
  final WarehouseController controller;

  const WarehouseSelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Obx(() {
        // Validación adicional de la lista
        if (controller.galponesFiltrados.isEmpty) {
          return const Center(child: Text('No hay galpones disponibles'));
        }

        return ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (int i = 0; i < controller.galponesFiltrados.length; i++)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.selectedWarehouse.value == i
                        ? const Color(0xFF26A69A)
                        : const Color(0xFFE0F2F1),
                    foregroundColor: controller.selectedWarehouse.value == i
                        ? Colors.white
                        : const Color(0xFF26A69A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    // Solución segura para evitar RangeError
                    try {
                      final selectedGalpon = controller.galponesFiltrados[i];
                      final indexInMainList = controller.galpones.indexWhere(
                        (g) => g.id == selectedGalpon.id);
                      
                      if (indexInMainList != -1) {
                        controller.selectWarehouse(indexInMainList);
                      } else {
                        Get.snackbar('Error', 'Galpón no encontrado en la lista principal');
                      }
                    } catch (e) {
                      Get.snackbar('Error', 'No se pudo seleccionar el galpón');
                    }
                  },
                  child: Text(controller.galponesFiltrados[i].nombre),
                ),
              ),
          ],
        );
      }),
    );
  }
}
