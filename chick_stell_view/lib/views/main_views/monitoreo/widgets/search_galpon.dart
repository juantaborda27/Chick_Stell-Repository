import 'package:flutter/material.dart';
import 'package:chick_stell_view/controllers/warehouse_controller.dart';

class SearchGalpon extends StatelessWidget {
  final WarehouseController controller;

  const SearchGalpon({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar galpón...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onChanged: controller.updateSearch,
      ),
    );
  }
}

