import 'package:chick_stell_view/controllers/warehouse_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarehouseSelector extends StatelessWidget {
  final WarehouseController controller;

  const WarehouseSelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Obx(() => ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (int i = 1; i <= controller.warehouseCount.value; i++)
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
                // onPressed: () => controller.selectWarehouse(i),
                onPressed: (){},
                child: Text('Galpón $i'),
              ),
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: (){},
            child: Row(
              children: const [
                Icon(Icons.add),
                SizedBox(width: 0.2),
              ],
            ),
          ),
        ],
      )),
    );
  }
}

