// simulacion_view.dart (Vista)
import 'package:chick_stell_view/controllers/simulacion_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SimulacionView extends StatelessWidget {
  final controller = Get.put(SimulacionController());

  SimulacionView({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Simulación de Galpones")),
      body: Column(
        children: [
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: 
                  controller.simulando.value
                      ? controller.detenerSimulacion
                      : controller.iniciarSimulacion,
                  child: Text(
                    controller.simulando.value ? "Detener" : "Iniciar",
                  ),
                ),
                ElevatedButton(
                  onPressed: controller.forzarEstresTermico,
                  child: const Text("Forzar Estrés Térmico"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => Expanded(
              child: ListView.builder(
                itemCount: controller.galpones.length,
                itemBuilder: (context, index) {
                  final s = controller.galpones[index];
                  return Card(
                    child: ListTile(
                      title: Text("Galpón ${s.id}"),
                      subtitle: Text(
                        "Temp: ${s.temperaturaInterna.toStringAsFixed(2)}°C\n"
                        "Humedad: ${s.humedadInterna.toStringAsFixed(2)}%",
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const Divider(),
          ValueListenableBuilder(
            valueListenable: Hive.box("predicciones").listenable(),
            builder: (context, box, _) {
              return Column(
                children: controller.galpones.map((sensor) {
                  final List? predList = box.get(sensor.id);
                  if (predList == null || predList.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    child: ExpansionTile(
                      title: Text("Predicciones Galpón ${sensor.id}"),
                      children: predList.map<Widget>((pred) {
                        final bool hayEstres = pred["estres_termico"] == 1;
                        final double prob = pred["probabilidad"];
                        final double conf = pred["confianza"];
                        final color = hayEstres
                            ? (prob > 0.6 && conf > 0.6
                                ? Colors.red
                                : Colors.orange)
                            : Colors.green;

                        final hora = DateTime.tryParse(
                          pred["hora"] ?? "",
                        )?.toLocal();
                        final horaTexto = hora != null
                            ? "${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')} - ${hora.day}/${hora.month}"
                            : "Hora desconocida";

                        return ListTile(
                          leading: Icon(
                            hayEstres ? Icons.warning : Icons.check_circle,
                            color: color,
                          ),
                          title: Text(horaTexto),
                          subtitle: Text(
                            "Estrés Térmico: ${hayEstres ? "Sí" : "No"}\n"
                            "Probabilidad: ${(prob * 100).toStringAsFixed(1)}%\n"
                            "Confianza: ${(conf * 100).toStringAsFixed(1)}%",
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          Obx(
            () => controller.forzandoEstres.value
                ? LinearProgressIndicator(
                    value: controller.progresoEstres / 100,
                    backgroundColor: Colors.red[100],
                    color: Colors.red,
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
