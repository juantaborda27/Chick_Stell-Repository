import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SimulacionController extends GetxController {
  Timer? _timer;

  // Estado observable para saber si la simulación está activa
  RxBool simulando = false.obs;

  // Contador de envíos realizados
  RxInt contadorEnvios = 0.obs;

  // Inicia la simulación
  void iniciarSimulacion() {
    if (_timer != null && _timer!.isActive) return;

    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      final random = Random();

      final temperaturaAmbiente = 28 + random.nextDouble() * 7;  // 28 a 35
      final humedadRelativa = 60 + random.nextDouble() * 30;     // 60 a 90
      final velocidadViento = random.nextDouble() * 5;           // 0 a 5 m/s
      final temperaturaInterior = 30 + random.nextDouble() * 5;  // 30 a 35
      final humedadInterior = 65 + random.nextDouble() * 20;     // 65 a 85

      final data = {
        'timestamp': DateTime.now().toIso8601String(),
        'temperatura_ambiente': double.parse(temperaturaAmbiente.toStringAsFixed(2)),
        'humedad_relativa': double.parse(humedadRelativa.toStringAsFixed(2)),
        'velocidad_viento': double.parse(velocidadViento.toStringAsFixed(2)),
        'temperatura_interior': double.parse(temperaturaInterior.toStringAsFixed(2)),
        'humedad_interior': double.parse(humedadInterior.toStringAsFixed(2)),
      };

      FirebaseFirestore.instance.collection('datos_sensores').add(data);
      contadorEnvios.value++;
    });

    simulando.value = true;
  }

  // Detiene la simulación
  void detenerSimulacion() {
    _timer?.cancel();
    simulando.value = false;
  }

  // Limpiar el temporizador al destruir el controlador
  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
