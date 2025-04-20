

//import 'package:chick_stell_view/controllers/prediccion_controller.dart';
import 'package:chick_stell_view/controllers/simulacion_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrediccionView extends StatelessWidget {

  PrediccionView({super.key});

  final SimulacionController simController = Get.put(SimulacionController());
  //final PrediccionController predController = Get.put(PrediccionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simulación de Datos IoT')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                simController.simulando.value
                    ? '🟢 Simulación en curso'
                    : '🔴 Simulación detenida',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  simController.simulando.value
                      ? simController.detenerSimulacion()
                      : simController.iniciarSimulacion();
                },
                child: Text(simController.simulando.value
                    ? 'Detener simulación'
                    : 'Iniciar simulación'),
              ),
              const SizedBox(height: 20),
              Text(
                'Datos enviados: ${simController.contadorEnvios}',
                style: TextStyle(fontSize: 16),
              ),
              const Divider(height: 40),
              Text(
                '🔍 Última predicción',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // const SizedBox(height: 10),
              // Text('Nivel de Estrés: ${predController.nivelEstres}', style: TextStyle(fontSize: 16)),
              // Text('Confianza: ${(predController.confianza.value * 100).toStringAsFixed(1)}%', style: TextStyle(fontSize: 16)),
              // Text('Mensaje: ${predController.mensaje}', style: TextStyle(fontSize: 14)),
            ],
          )),
        ),
      ),
    );
  }
}