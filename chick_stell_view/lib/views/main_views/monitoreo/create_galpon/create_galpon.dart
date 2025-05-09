import 'package:chick_stell_view/controllers/galpon_controller.dart';
import 'package:chick_stell_view/models/galpon_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart';

class CreateGalpon extends StatefulWidget {
  const CreateGalpon({super.key});

  @override
  CreateGalponState createState() => CreateGalponState();
}

class CreateGalponState extends State<CreateGalpon> with SingleTickerProviderStateMixin {
  // Controladores para los campos de texto
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController largoController = TextEditingController();
  final TextEditingController anchoController = TextEditingController();
  final TextEditingController edadDiasController = TextEditingController();
  final TextEditingController densidadPollosController = TextEditingController();
  final TextEditingController ventiladoresController = TextEditingController();
  final TextEditingController nebulizadoresController = TextEditingController();
  final TextEditingController sensoresController = TextEditingController();
  
  // Controlador de animación para efectos visuales
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Colores de la aplicación
  final Color primaryColor = const Color(0xFF0F4C3A);
  final Color accentColor = const Color(0xFF26A69A);
  final Color backgroundColor = Colors.white;
  final Color errorColor = Colors.red.shade700;

  // Validación del formulario
  final _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    nombreController.dispose();
    largoController.dispose();
    anchoController.dispose();
    edadDiasController.dispose();
    densidadPollosController.dispose();
    ventiladoresController.dispose();
    nebulizadoresController.dispose();
    sensoresController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 10,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: _autovalidate 
                        ? AutovalidateMode.onUserInteraction 
                        : AutovalidateMode.disabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildDivider('Información Básica'),
                        _buildTextField(
                          label: 'Nombre del Galpón',
                          hintText: 'Ingrese el nombre del galpón',
                          controller: nombreController,
                          keyboardType: TextInputType.text,
                          icon: Icons.warehouse_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese un nombre';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                label: 'Largo (m)',
                                hintText: 'Largo',
                                controller: largoController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                icon: Icons.straighten,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Requerido';
                                  }
                                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                                    return 'Valor inválido';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                label: 'Ancho (m)',
                                hintText: 'Ancho',
                                controller: anchoController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                icon: Icons.swap_horiz,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Requerido';
                                  }
                                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                                    return 'Valor inválido';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildDivider('Equipamiento'),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                label: 'Ventiladores',
                                hintText: 'Cantidad',
                                controller: ventiladoresController,
                                keyboardType: TextInputType.number,
                                icon: Icons.air,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Requerido';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                label: 'Nebulizadores',
                                hintText: 'Cantidad',
                                controller: nebulizadoresController,
                                keyboardType: TextInputType.number,
                                icon: Icons.water_drop_outlined,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Requerido';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'Sensores',
                          hintText: 'Ingrese la cantidad de sensores',
                          controller: sensoresController,
                          keyboardType: TextInputType.number,
                          icon: Icons.sensors,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese la cantidad de sensores';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildInfoCard(),
                        const SizedBox(height: 24),
                        _buildActionButtons(context),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: accentColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: accentColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Las dimensiones afectarán los cálculos de densidad y ventilación.',
              style: TextStyle(
                fontSize: 13,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 1,
              color: Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.add_business, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                'Agregar Nuevo Galpón',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.95),
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Colors.white70),
            splashRadius: 20,
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
    IconData? icon,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: primaryColor.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: icon != null ? Icon(icon, color: accentColor) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: accentColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: errorColor),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            setState(() {
              _autovalidate = true;
            });
            
            if (_formKey.currentState?.validate() ?? false) {
              final galponController = Get.find<GalponController>();
              final Uuid uuid = const Uuid();

              // Generar ID único
              final String id = uuid.v4();

              // Crear el objeto Galpon
              final galpon = Galpon(
                id: id,
                nombre: nombreController.text,
                largo: double.tryParse(largoController.text) ?? 0,
                ancho: double.tryParse(anchoController.text) ?? 0,
                edadDias: int.tryParse(edadDiasController.text) ?? 0,
                densidadPollos: double.tryParse(densidadPollosController.text) ?? 0.0,
                ventiladores: int.tryParse(ventiladoresController.text) ?? 0,
                nebulizadores: int.tryParse(nebulizadoresController.text) ?? 0,
                sensores: int.tryParse(sensoresController.text) ?? 0,
              );

              // Mostrar indicador de carga
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );

              try {
                await galponController.agregarGalpon(galpon);
                await galponController.cargarGalpones();
                
                // Cerrar el indicador de carga
                Navigator.of(context).pop();
                
                // Mostrar mensaje de éxito y cerrar el diálogo
                _showSuccessMessage(context);
              } catch (e) {
                // Cerrar el indicador de carga
                Navigator.of(context).pop();
                
                // Mostrar mensaje de error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error al crear el galpón: ${e.toString()}'),
                    backgroundColor: errorColor,
                  ),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
          ),
          icon: const Icon(Icons.save),
          label: const Text(
            'AGREGAR GALPÓN',
            style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey.shade700,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('CANCELAR'),
        ),
      ],
    );
  }

  void _showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Galpón creado exitosamente'),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
    
    Navigator.of(context).pop(); // Cerrar el diálogo
  }
}