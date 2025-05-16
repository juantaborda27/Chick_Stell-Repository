import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:chick_stell_view/controllers/simulacion_controller.dart';

class SimulacionView extends StatelessWidget {
  final SimulacionController controller = Get.put(SimulacionController());

  // Color palette based on Image 2
  final Color primaryColor = const Color(0xFF118C8C);
  final Color secondaryColor = const Color(0xFF04403A);
  final Color accentColor = const Color(0xFFF29D35);
  final Color tertiaryColor = const Color(0xFFA66E4E);
  final Color bgColor = const Color(0xFFF2F2F2);

  SimulacionView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SimulacionController());
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text("Sistema de Predicción de Estrés Térmico"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Control Panel
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              color: primaryColor.withOpacity(0.9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(() => ElevatedButton.icon(
                        onPressed: controller.simulando.value
                            ? controller.detenerSimulacion
                            : controller.iniciarSimulacion,
                        icon: Icon(
                          controller.simulando.value ? Icons.stop : Icons.play_arrow,
                          color: primaryColor,
                        ),
                        label: Text(
                          controller.simulando.value ? "Detener" : "Iniciar",
                          style: TextStyle(color: primaryColor),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                    ),
                  ElevatedButton.icon(
                    onPressed: controller.forzarEstresTermico,
                    icon: Icon(Icons.thermostat, color: secondaryColor),
                    label: const Text("Forzar Estrés Térmico"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: secondaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),

            // Progress Indicator for Stress Simulation
            Obx(
              () => controller.forzandoEstres.value
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Simulando estrés térmico...",
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: controller.progresoEstres / 100,
                            backgroundColor: Colors.red[100],
                            color: Colors.red,
                            minHeight: 8,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ),

            const SizedBox(height: 24),

            // Predictions Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSectionHeader("Predicciones de Estrés Térmico"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ValueListenableBuilder(
                valueListenable: Hive.box("predicciones").listenable(),
                builder: (context, box, _) {
                  return Column(
                    children: controller.galpones.map((galpon) {
                      final List? predList = box.get(galpon.id);
                      if (predList == null || predList.isEmpty) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "No hay predicciones disponibles para Galpón ${galpon.nombre}",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        );
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ExpansionTile(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.analytics, color: primaryColor),
                          ),
                          title: Text(
                            "Predicciones Galpón ${galpon.nombre}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: secondaryColor,
                            ),
                          ),
                          children: [
                            ...predList.map<Widget>((pred) {
                              final bool hayEstres = pred["estres_termico"] == 1;
                              final double prob = pred["probabilidad"] ?? 0.0;
                              final double conf = pred["confianza"] ?? 0.0;

                              Color statusColor;
                              String statusText;

                              if (hayEstres) {
                                if (prob > 0.8) {
                                  statusColor = Colors.red;
                                  statusText = "Alto Riesgo";
                                } else {
                                  statusColor = accentColor;
                                  statusText = "Riesgo Moderado";
                                }
                              } else {
                                statusColor = Colors.green;
                                statusText = "Bajo Riesgo";
                              }

                              final hora = DateTime.tryParse(pred["hora"] ?? "");
                              final horaTexto = hora != null
                                  ? "${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')} - ${hora.day}/${hora.month}"
                                  : "Fecha desconocida";

                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: Colors.grey.withOpacity(0.1)),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: statusColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: statusColor),
                                          ),
                                          child: Text(
                                            statusText,
                                            style: TextStyle(
                                              color: statusColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          horaTexto,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        _buildIndicator(
                                          "Probabilidad",
                                          "${(prob * 100).toStringAsFixed(0)}%",
                                          prob,
                                          statusColor,
                                        ),
                                        const SizedBox(width: 12),
                                        _buildIndicator(
                                          "Confianza",
                                          "${(conf * 100).toStringAsFixed(0)}%",
                                          conf,
                                          Colors.blueAccent,
                                        ),
                                      ],
                                    ),
                                    if (hayEstres && prob > 0.6)
                                      Container(
                                        margin: const EdgeInsets.only(top: 12),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.amber.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.amber),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.warning_amber, color: Colors.amber),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                "Se recomienda activar nebulizadores y verificar la ventilación",
                                                style: TextStyle(color: Colors.amber[800]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Stats Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSectionHeader("Métricas de Confianza"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.analytics, color: primaryColor),
                              const SizedBox(width: 4),
                              Text(
                                "Confianza IA",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: secondaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ValueListenableBuilder(
                            valueListenable: Hive.box("predicciones").listenable(),
                            builder: (context, box, _) {
                              final promedio = controller.calcularPromedioConfianza(box);
                              final texto = "${(promedio * 100).toStringAsFixed(0)}%";

                              return Text(
                                texto,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              );
                            },
                          ),
                          Text(
                            "Basado en datos históricos",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 1,
                      color: Colors.grey.withOpacity(0.2),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.update, color: accentColor),
                              const SizedBox(width: 4),
                              Text(
                                "Última Actualización",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: secondaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ValueListenableBuilder(
                            valueListenable: Hive.box("predicciones").listenable(),
                            builder: (context, box, _) {
                              final texto = controller.obtenerHoraGeneracion(box);
                              return Text(
                                texto,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: secondaryColor,
                                ),
                              );
                            },
                          ),
                          Text(
                            "Próxima: 13:45",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Add extra space at the bottom to ensure all content is visible
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
    // <-- Add this closing parenthesis for the build method
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12, top: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: secondaryColor,
        ),
      ),
    );
  }

  Widget _buildIndicator(String label, String value, double percentage, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: color.withOpacity(0.1),
              color: color,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}