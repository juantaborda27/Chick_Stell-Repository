import 'package:animate_do/animate_do.dart';
import 'package:chick_stell_view/controllers/warehouse_controller.dart';
import 'package:chick_stell_view/models/galpon_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditGalpon extends StatelessWidget {
  final Galpon galpon;

  EditGalpon({Key? key, required this.galpon}) : super(key: key);

  final WarehouseController warehouseController = Get.find<WarehouseController>();
  final _formKey = GlobalKey<FormState>();

  // Colores de la aplicación
  final Color primaryColor = const Color(0xFF0F4C3A);
  final Color accentColor = const Color(0xFF26A69A);
  final Color backgroundColor = Colors.white;
  final Color errorColor = Colors.redAccent;
  final Color deleteColor = Colors.red.shade600;
  final Color iconColor = const Color(0xFF26A69A);

  @override
  Widget build(BuildContext context) {
    final nombreController = TextEditingController(text: galpon.nombre);
    final largoController = TextEditingController(text: galpon.largo.toString());
    final anchoController = TextEditingController(text: galpon.ancho.toString());
    final ventiladoresController = TextEditingController(text: galpon.ventiladores.toString());
    final nebulizadoresController = TextEditingController(text: galpon.nebulizadores.toString());
    final sensoresController = TextEditingController(text: galpon.sensores.toString());

    return Scaffold(
      appBar: AppBar(
        title: FadeIn(
          duration: const Duration(milliseconds: 500),
          child: const Text('Editar Galpón', 
            style: TextStyle(fontWeight: FontWeight.bold)
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 2,
        leading: FadeInLeft(
          duration: const Duration(milliseconds: 400),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Get.back(),
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      floatingActionButton: ZoomIn(
        delay: const Duration(milliseconds: 300),
        child: FloatingActionButton(
          backgroundColor: deleteColor,
          onPressed: () => _mostrarDialogoEliminar(context),
          child: const Icon(Icons.delete_forever, size: 28),
        ),
      ),
      body: Obx(() {
        return WarehouseController().isProcessing.value
            ? Center(
                child: SpinPerfect(
                  infinite: true,
                  duration: const Duration(seconds: 2),
                  child: const Icon(Icons.sync, size: 60, color: Color(0xFF26A69A)),
                ),
              )
            : FadeIn(
                duration: const Duration(milliseconds: 800),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        FadeInUp(
                          delay: const Duration(milliseconds: 200),
                          child: _buildHeaderCard(),
                        ),
                        const SizedBox(height: 20),
                        FadeInLeft(
                          delay: const Duration(milliseconds: 300),
                          child: _buildTextField('Nombre', nombreController, Icons.warehouse),
                        ),
                        FadeInRight(
                          delay: const Duration(milliseconds: 350),
                          child: _buildTextField('Largo (m)', largoController, Icons.straighten, isNumeric: true),
                        ),
                        FadeInLeft(
                          delay: const Duration(milliseconds: 400),
                          child: _buildTextField('Ancho (m)', anchoController, Icons.width_normal, isNumeric: true),
                        ),
                        FadeInRight(
                          delay: const Duration(milliseconds: 450),
                          child: _buildTextField('Ventiladores', ventiladoresController, Icons.air, isNumeric: true),
                        ),
                        FadeInLeft(
                          delay: const Duration(milliseconds: 500),
                          child: _buildTextField('Nebulizadores', nebulizadoresController, Icons.blur_on, isNumeric: true),
                        ),
                        FadeInRight(
                          delay: const Duration(milliseconds: 550),
                          child: _buildTextField('Sensores', sensoresController, Icons.sensors, isNumeric: true),
                        ),
                        const SizedBox(height: 30),
                        BounceInUp(
                          delay: const Duration(milliseconds: 600),
                          child: _buildSaveButton(
                            nombreController, 
                            largoController, 
                            anchoController,
                            ventiladoresController,
                            nebulizadoresController,
                            sensoresController
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
      }),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.edit_note, size: 42, color: accentColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Editando: ${galpon.nombre}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Dimensiones: ${galpon.largo}m × ${galpon.ancho}m',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, 
      TextEditingController controller, 
      IconData icon, 
      {bool isNumeric = false}
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es obligatorio';
          }
          if (isNumeric && double.tryParse(value) == null) {
            return 'Debe ser un número válido';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: iconColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: accentColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: accentColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
    );
  }

  Widget _buildSaveButton(
    TextEditingController nombreController,
    TextEditingController largoController,
    TextEditingController anchoController,
    TextEditingController ventiladoresController,
    TextEditingController nebulizadoresController,
    TextEditingController sensoresController,
  ) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          warehouseController.isProcessing.value = true;

          final editedGalpon = galpon.copyWith(
            nombre: nombreController.text,
            largo: double.parse(largoController.text),
            ancho: double.parse(anchoController.text),
            ventiladores: int.parse(ventiladoresController.text),
            nebulizadores: int.parse(nebulizadoresController.text),
            sensores: int.parse(sensoresController.text),
          );

          await warehouseController.actualizarGalpon(editedGalpon.id, editedGalpon);
          warehouseController.isProcessing.value = false;
          Get.back();
          Get.snackbar(
            'Actualizado', 
            'Galpón actualizado correctamente',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: accentColor.withOpacity(0.7),
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(10),
            icon: const Icon(Icons.check_circle, color: Colors.white),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.save, size: 24),
          SizedBox(width: 12),
          Text(
            'GUARDAR CAMBIOS',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoEliminar(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: deleteColor, size: 28),
              const SizedBox(width: 10),
              const Text('Confirmar eliminación'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('¿Estás seguro de que deseas eliminar este galpón?'),
              const SizedBox(height: 10),
              Text(
                'Nombre: ${galpon.nombre}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text('Esta acción no se puede deshacer.',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Cancelar', style: TextStyle(color: Colors.grey.shade700)),
            ),
            ElasticIn(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: deleteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  Get.back();
                  warehouseController.isProcessing.value = true;
                  await warehouseController.eliminarGalpon(galpon.id);
                  warehouseController.isProcessing.value = false;
                  Get.back();
                  Get.snackbar(
                    'Eliminado', 
                    'El galpón ha sido eliminado correctamente',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: deleteColor.withOpacity(0.7),
                    colorText: Colors.white,
                    duration: const Duration(seconds: 3),
                    margin: const EdgeInsets.all(10),
                    icon: const Icon(Icons.delete_forever, color: Colors.white),
                  );
                },
                child: const Text('Eliminar'),
              ),
            ),
          ],
        );
      },
    );
  }
}