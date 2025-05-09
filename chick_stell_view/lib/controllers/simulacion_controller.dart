import 'dart:async';
import 'dart:convert';
import 'package:chick_stell_view/models/galpon_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

class SimulacionController extends GetxController {
  final galpones = <Galpon>[].obs;
  final simulando = false.obs;
  final forzandoEstres = false.obs;
  Timer? _timer;
  int progresoEstres = 0;

  @override
  void onInit() {
    super.onInit();
    _cargarGalponesDesdeFirebase();
  }

  void iniciarSimulacion() {
    simulando.value = true;
    _timer = Timer.periodic(Duration(seconds: 10), (_) => _simular());
  }

  void detenerSimulacion() {
    simulando.value = false;
    _timer?.cancel();
  }

  void forzarEstresTermico() {
    forzandoEstres.value = true;
    progresoEstres = 0;
  }

  Future<void> _cargarGalponesDesdeFirebase() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection("galpones").get();

    final lista = snapshot.docs.map((e) {
      final data = e.data();
      data['id'] = e.id; 
      return Galpon.fromJson(data);
    }).toList();

      galpones.addAll(lista);
    } catch (e) {
      print("❌ Error al cargar galpones desde Firebase: $e");
    } 
  }

  Future<void> _actualizarFirebase(Galpon galpon) async {
    final sensoresData = {
      "temperaturaInterna": galpon.temperaturaInterna,
      "humedadInterna": galpon.humedadInterna,
      "velocidadAire": galpon.velocidadAire,
    };

    try {
      await FirebaseFirestore.instance
          .collection("galpones")
          .doc(galpon.id)
          .update({
        "sensores_datos": sensoresData,
      });
      print("✅ Firebase actualizado para galpón ${galpon.id}");
    } catch (e) {
      print("❌ Error actualizando Firebase: $e");
    }
  }

  Future<void> _simular() async {
    _actualizarSensores();
    final body = {
      "galpones": galpones.map((s) => s.toPrediccionJson()).toList(),
      "forzar_estres": forzandoEstres.value,
    };
    try {
      final response = await http.post(
        Uri.parse("https://microservicioprediccion.onrender.com/predecir"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final box = await Hive.openBox("predicciones");

        for (var galpon in galpones) {
          final List predicciones = data["predicciones"][galpon.id];
          if (predicciones.isEmpty) continue;

          final List? anterior = box.get(galpon.id);
          final ultima = predicciones.last;

          // Detectar si hubo cambio significativo para guardar y actualizar
          final cambio = anterior == null ||
              (ultima["estres_termico"] != anterior.last["estres_termico"] ||
                  (ultima["probabilidad"] - anterior.last["probabilidad"])
                          .abs() >
                      0.2 ||
                  (ultima["confianza"] - anterior.last["confianza"]).abs() >
                      0.2);

          if (cambio) {
            box.put(galpon.id, predicciones);

            // Aqui se envia al firebase

            if (ultima["estres_termico"] == 1 &&
                ultima["probabilidad"] > 0.6 &&
                ultima["confianza"] > 0.6) {
              _activarVentilador(galpon.id);
            }
          }
        }
      } else {
        print(
          "❌ Error en respuesta: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e) {
      print("❌ Error en la simulación: $e");
    } finally {
      if (forzandoEstres.value) {
        progresoEstres++;
        if (progresoEstres >= 10) {
          forzandoEstres.value = false;
          progresoEstres = 0;
        }
      }
    }
  }

  void _activarVentilador(String idGalpon) {
    print("🌀 Ventilador activado en $idGalpon");
  }

  /// Simula cambios leves en los sensores con lógica realista
  void _actualizarSensores() {
    final random = Random();

    for (var sensor in galpones) {
      // Simulación más lenta y realista
      sensor.temperaturaInterna += (random.nextDouble() - 0.5) * 0.1;
      sensor.humedadInterna += (random.nextDouble() - 0.5) * 0.5;
      sensor.velocidadAire += (random.nextDouble() - 0.5) * 0.03;

      // Limitar los valores a rangos razonables
      sensor.temperaturaInterna = sensor.temperaturaInterna.clamp(24.0, 35.0);
      sensor.humedadInterna = sensor.humedadInterna.clamp(40.0, 90.0);
      sensor.velocidadAire = sensor.velocidadAire.clamp(0.5, 3.0);
      _actualizarFirebase(sensor);
    }
    galpones.refresh();
  }
}
