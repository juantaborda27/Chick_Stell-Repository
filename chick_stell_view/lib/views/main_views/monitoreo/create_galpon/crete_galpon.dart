



import 'package:chick_stell_view/views/main_views/monitoreo/create_galpon/widgets_create_galpon/build_field.dart';
import 'package:flutter/material.dart';

class CreteGalpon extends StatelessWidget {
  const CreteGalpon({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: 400
        ),
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
                  BuildField(
                    label: 'Nombre del Galpón',
                    hintText: 'Ingrese el nombre del galpón',
                    controller: null,
                    obscureText: false,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 16,),
                  BuildField(
                    label: 'Largo',
                    hintText: 'Ingrese el largo en (M)',
                    controller: null,
                    obscureText: false,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 16,),
                  BuildField(
                    label: 'Ancho',
                    hintText: 'Ingrese el ancho en (M)',
                    controller: null,
                    obscureText: false,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 16,),
                  BuildField(
                    label: 'Area Total',
                    hintText: 'Ingrese el area total en (M^2)',
                    controller: null,
                    obscureText: false,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 16,),
                  BuildField(
                    label: 'Cantidad de Ventiladores',
                    hintText: 'Ingrese la cantidad de ventiladores',
                    controller: null,
                    obscureText: false,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 16,),
                  BuildField(
                    label: 'Cantidad de Nebulizadores',
                    hintText: 'Ingrese la cantidad de nebulizadores',
                    controller: null,
                    obscureText: false,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 16,),
                  BuildField(
                    label: 'Cantidad de Pollos',
                    hintText: 'Ingrese la cantidad de Pollos',
                    controller: null,
                    obscureText: false,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 16,),
                  BuildField(
                    label: 'Tipo de Galpon',
                    hintText: 'Ingrese el tipo de galpón',
                    controller: null,
                    obscureText: false,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 24,),
                  _buildActionButtons(context),
                ],
              ),
            )
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
            'Agregar Nuevo Galpón',
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


  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF26A69A),
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Text('Agregar Galpón'),
        ),
        SizedBox(height: 8),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: Colors.brown,
            minimumSize: Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Text('Cancelar'),
        ),
      ],
    );
  }


}