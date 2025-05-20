import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chick_stell_view/controllers/warehouse_controller.dart';
import 'package:chick_stell_view/views/main_views/monitoreo/create_galpon/create_galpon.dart';

class SearchGalpon extends StatelessWidget {
  final WarehouseController controller;
  
  const SearchGalpon({super.key, required this.controller});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Logo de la aplicación
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image.asset(
                'assets/images/logo2.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Campo de búsqueda
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar galpón...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: controller.updateSearch,
            ),
          ),
          const SizedBox(width: 8),
          // Botón para añadir
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            onPressed: () {
              Get.dialog(const CreateGalpon());
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}