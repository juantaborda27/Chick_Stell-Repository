import 'package:chick_stell_view/controllers/galpon_controller.dart';
import 'package:chick_stell_view/models/galpon_model.dart';
import 'package:chick_stell_view/services/galpon_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditGalpon extends StatefulWidget {
  final Galpon galpon;

  const EditGalpon({super.key, required this.galpon});

  @override
  EditGalponState createState() => EditGalponState();
}

class EditGalponState extends State<EditGalpon> {
  final GalponService galponService = Get.find<GalponService>();
  final GalponController galponController = Get.find<GalponController>();


  late TextEditingController nombreController;
  late TextEditingController largoController;
  late TextEditingController anchoController;
  late TextEditingController ventiladoresController;
  late TextEditingController nebulizadoresController;
  late TextEditingController sensoresController;

  @override
  void initState() {
    super.initState();
    final g = widget.galpon;
    nombreController = TextEditingController(text: g.nombre);
    largoController = TextEditingController(text: g.largo.toString());
    anchoController = TextEditingController(text: g.ancho.toString());
    ventiladoresController = TextEditingController(text: g.ventiladores.toString());
    nebulizadoresController = TextEditingController(text: g.nebulizadores.toString());
    sensoresController = TextEditingController(text: g.sensores.toString());
  }

  @override
  void dispose() {
    nombreController.dispose();
    largoController.dispose();
    anchoController.dispose();
    ventiladoresController.dispose();
    nebulizadoresController.dispose();
    sensoresController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                    label: 'Nombre del Galpón',
                    hintText: 'Ingrese el nombre del galpón',
                    controller: nombreController,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    label: 'Largo',
                    hintText: 'Ingrese el largo en metros',
                    controller: largoController,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    label: 'Ancho',
                    hintText: 'Ingrese el ancho en metros',
                    controller: anchoController,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    label: 'Cantidad de Ventiladores',
                    hintText: 'Ingrese la cantidad de ventiladores',
                    controller: ventiladoresController,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    label: 'Cantidad de Nebulizadores',
                    hintText: 'Ingrese la cantidad de nebulizadores',
                    controller: nebulizadoresController,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    label: 'Cantidad de Sensores',
                    hintText: 'Ingrese la cantidad de sensores',
                    controller: sensoresController,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 24),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Editar Galpón',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0F4C3A),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(Icons.close, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required TextInputType keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
  return Column(
    children: [
      ElevatedButton(
        onPressed: () async {
          final galponEditado = widget.galpon.copyWith(
            nombre: nombreController.text,
            largo: double.tryParse(largoController.text) ?? 0,
            ancho: double.tryParse(anchoController.text) ?? 0,
            ventiladores: int.tryParse(ventiladoresController.text) ?? 0,
            nebulizadores: int.tryParse(nebulizadoresController.text) ?? 0,
            sensores: int.tryParse(sensoresController.text) ?? 0,
          );

          await galponService.updateGalpon(galponEditado.id, galponEditado.toJson());
          galponController.cargarGalpones;

          // setState(() {}); 

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Galpón actualizado')),
          );
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF26A69A),
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Text('Guardar Cambios'),
      ),
      SizedBox(height: 8),
      TextButton(
        onPressed: () async {
          await galponService.deleteGalpon(widget.galpon.id);
          await galponController.cargarGalpones;

          // setState(() {}); 
          ScaffoldMessenger.of(context).showSnackBar( 
            SnackBar(content: Text('Galpón eliminado')),
          );
          Navigator.of(context).pop();
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.red,
          minimumSize: Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Text('Eliminar Galpón'),
      ),
    ],
  );
}

}
