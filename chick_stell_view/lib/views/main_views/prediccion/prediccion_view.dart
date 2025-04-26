

import 'package:chick_stell_view/controllers/prediccion_controller.dart';
import 'package:chick_stell_view/controllers/simulacion_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrediccionView extends StatelessWidget {
  PrediccionView({super.key});

  final SimulacionController simController = Get.put(SimulacionController());
  final PrediccionController predController = Get.put(PrediccionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Simulación de Datos IoT'),
      //   elevation: 2,
      //   centerTitle: true,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sección de Simulación
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          simController.simulando.value
                              ? Icons.sensors
                              : Icons.sensors_off,
                          color: simController.simulando.value
                              ? Colors.green
                              : Colors.red,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Estado de Simulación',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: simController.simulando.value
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: simController.simulando.value
                              ? Colors.green
                              : Colors.red,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            simController.simulando.value
                                ? Icons.circle
                                : Icons.circle_outlined,
                            color: simController.simulando.value
                                ? Colors.green
                                : Colors.red,
                            size: 14,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            simController.simulando.value
                                ? 'Simulación en curso'
                                : 'Simulación detenida',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: simController.simulando.value
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Datos enviados: ${simController.contadorEnvios}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 46,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          simController.simulando.value
                              ? simController.detenerSimulacion()
                              : simController.iniciarSimulacion();
                        },
                        icon: Icon(simController.simulando.value
                            ? Icons.stop_circle
                            : Icons.play_circle),
                        label: Text(simController.simulando.value
                            ? 'Detener simulación'
                            : 'Iniciar simulación'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: simController.simulando.value
                              ? Colors.red.shade700
                              : Colors.green.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Sección de Predicción
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.analytics,
                          color: Theme.of(context).colorScheme.primary,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Análisis Predictivo',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Nivel de estrés con indicador visual
                    _buildMetricaRow(
                      context,
                      'Nivel de Estrés',
                      predController.nivelEstres.value,
                      _getNivelEstresColor(predController.nivelEstres.value),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Confianza con barra de progreso
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Confianza:',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Stack(
                          children: [
                            Container(
                              height: 10,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            Container(
                              height: 10,
                              width: MediaQuery.of(context).size.width * 
                                  (predController.confianza.value * 0.6), // Ajuste para que no ocupe todo el ancho
                              decoration: BoxDecoration(
                                color: _getConfianzaColor(predController.confianza.value),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${(predController.confianza.value * 100).toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _getConfianzaColor(predController.confianza.value),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Mensaje con fondo resaltado
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mensaje:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${predController.mensaje}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
  
  Widget _buildMetricaRow(BuildContext context, String titulo, String valor, Color colorValor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$titulo:',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          decoration: BoxDecoration(
            color: colorValor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorValor, width: 1),
          ),
          child: Text(
            valor,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorValor,
            ),
          ),
        ),
      ],
    );
  }
  
  Color _getNivelEstresColor(String nivel) {
    switch (nivel.toLowerCase()) {
      case 'alto':
      case 'crítico':
        return Colors.red;
      case 'medio':
      case 'moderado':
        return Colors.orange;
      case 'bajo':
      case 'normal':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }
  
  Color _getConfianzaColor(double confianza) {
    if (confianza >= 0.7) return Colors.green;
    if (confianza >= 0.4) return Colors.orange;
    return Colors.red;
  }
}