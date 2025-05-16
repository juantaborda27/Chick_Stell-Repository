import 'dart:async';
import 'dart:convert';
import 'package:chick_stell_view/controllers/warehouse_controller.dart';
import 'package:chick_stell_view/models/galpon_model.dart';
import 'package:chick_stell_view/services/city_weather_service.dart';
import 'package:chick_stell_view/services/galpon_service.dart';
import 'package:chick_stell_view/services/notification_service.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

import 'package:intl/intl.dart';

class SimulacionController extends GetxController {
  final GalponService _galponService = GalponService();
  final CityWeatherService _cityWeatherService = Get.put(CityWeatherService());
  final galpones = <Galpon>[].obs;
  final simulando = false.obs;
  final forzandoEstres = false.obs;
  Timer? _timer;
  int progresoEstres = 0;

  //longtid y latitud
  double? latitud;
  double? longitud;

  @override
  void onInit() {
    super.onInit();
    _cargarGalponesDesdeFirebase();
    obtenerLatitudLongitud();
    _cityWeatherService.actualizarClimaExterior(); // Primera vez
    Timer.periodic(Duration(minutes: 10),
        (_) => _cityWeatherService.actualizarClimaExterior());
  }

  obtenerLatitudLongitud() async {
    try {
      final location = await _cityWeatherService.getLocation();
      if (location != null) {
        latitud = location['latitude'];
        longitud = location['longitude'];
      }
    } catch (e) {}
  }

  void iniciarSimulacion() {
    simulando.value = true;
    _timer = Timer.periodic(Duration(seconds: 10), (_) => _simular());
  }

  void detenerSimulacion() {
    simulando.value = false;
    _timer?.cancel();
  }

   void toggleSimulacion(bool value) {
    if (value) {
      iniciarSimulacion();
    } else {
      detenerSimulacion();
    }
  }

  void forzarEstresTermico() {
    forzandoEstres.value = true;
    progresoEstres = 0;
  }

  Future<void> _cargarGalponesDesdeFirebase() async {
    try {
      var resultado = await _galponService.getGalpones();
      galpones.assignAll(resultado);
    } catch (e) {
      Get.snackbar('Error', 'No se pudieron cargar los galpones');
    }
  }

  Future<void> _actualizarFirebase(Galpon galpon) async {
    try {
      await _galponService.updateGalpon(galpon.id, galpon.toJson());
      // _cargarGalponesDesdeFirebase();
      print("✅ Firebase actualizado para galpón ${galpon.id}");
    } catch (e) {
      print("❌ Error actualizando Firebase: $e");
    }
  }

  String getCurrentTime() {
    DateTime now = DateTime.now();
    // Formato: "yyyy-MM-ddTHH:mm:ss.SSS"
    return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").format(now);
  }

  Future<void> _simular() async {
    _actualizarSensores();

    final body = {
      "galpones": galpones.map((s) => s.toPrediccionJson()).toList(),
      "hora_actual": getCurrentTime(),
      "forzar_estres": forzandoEstres.value,
      "longitude": longitud,
      "latitude": latitud,
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

          final cambio = anterior == null ||
              (ultima["estres_termico"] != anterior.last["estres_termico"] ||
                  (ultima["probabilidad"] - anterior.last["probabilidad"])
                          .abs() >
                      0.2 ||
                  (ultima["confianza"] - anterior.last["confianza"]).abs() >
                      0.2);

          if (cambio) {
            box.put(galpon.id, predicciones);
            print("hubo cambio significativo en galpón ${galpon.id}");
            procesarYGuardarPredicciones(
              galpon: galpon,
              predicciones: predicciones.cast<Map<String, dynamic>>(),
            );

            // Buscar si alguna predicción indica riesgo
            final prediccionesCriticas = predicciones
                .where((p) =>
                    p["estres_termico"] == 1 &&
                    p["probabilidad"] > 0.4 &&
                    p["confianza"] >= 0.2)
                .toList();

            if (prediccionesCriticas.isNotEmpty) {
              final prediccionRiesgo = prediccionesCriticas.first;
              await NotificationService.showNotification(
                '⚠️ Alerta de Estrés Térmico',
                'El galpón "${galpon.nombre}" presenta riesgo de estrés térmico. Probabilidad: ${(prediccionRiesgo["probabilidad"] * 100).toStringAsFixed(1)}%',
                id: galpon.id.hashCode, // o usa un índice único si lo tienes
              );
              print("notificación enviada para galpón ${galpon.nombre}");
              ///////////////////////////////////////////////////////
              final warehouseController = Get.find<WarehouseController>();
              warehouseController.activarAlerta(
                '⚠️ Alerta de Estrés Térmico',
                'El galpón "${galpon.nombre}" presenta riesgo de estrés térmico.',
              );

              warehouseController.ventilationActive.value = true;
              Future.delayed(const Duration(seconds: 10), () {
                warehouseController.ventilationActive.value = false;
              });
            }
          }

          print(
              "✅ Predicción actualizada para galpón ${galpon.nombre}: ${ultima["estres_termico"] == 1 ? "Estrés Térmico" : "Sin Estrés"}");
        }
      } else {
        print(
            "❌ Error en respuesta: ${response.statusCode} - ${response.body}");
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

  Future<void> procesarYGuardarPredicciones({
    required Galpon galpon,
    required List<Map<String, dynamic>> predicciones,
  }) async {
    await _galponService.guardarPredicciones(
      idGalpon: galpon.id,
      nombreGalpon: galpon.nombre,
      predicciones: predicciones,
    );
  }

  void _actualizarSensores() {
    final random = Random();
    final now = DateTime.now();
    final factorHora = sin((now.hour / 24.0) * 2 * pi); // curva diaria

    for (var i = 0; i < galpones.length; i++) {
      final sensor = galpones[i];

      // Clima exterior
      double tempExterior = _cityWeatherService.temperaturaExterior ?? 30.0;
      double humedadExterior = _cityWeatherService.humedadExterior ?? 65.0;

      // Variación por galpón
      double ajusteGalpon = (random.nextDouble() - 0.5) * 2; // -1 a +1

      // Variación en temperatura y humedad según clima + galpón + hora
      double deltaTemp = (tempExterior - sensor.temperaturaInterna) * 0.05;
      double deltaHum = (humedadExterior - sensor.humedadInterna) * 0.05;

      deltaTemp += factorHora * 0.4 +
          ajusteGalpon * 0.3 +
          (random.nextDouble() - 0.5) * 0.2;
      deltaHum += factorHora * 1.5 +
          ajusteGalpon * 0.8 +
          (random.nextDouble() - 0.5) * 2.0;

      // Si se está forzando el estrés, forzamos aumento progresivo
      if (forzandoEstres.value) {
        deltaTemp += 0.1 + progresoEstres * 0.05;
        deltaHum += 0.5 + progresoEstres * 0.1;
      }

      // Aplicar cambios
      sensor.temperaturaInterna += deltaTemp;
      sensor.humedadInterna += deltaHum;
      sensor.velocidadAire += (random.nextDouble() - 0.5) * 0.03;

      // Limitar a rangos realistas
      sensor.temperaturaInterna = sensor.temperaturaInterna
          .clamp(22.0, forzandoEstres.value ? 38.0 : 35.0);
      sensor.humedadInterna =
          sensor.humedadInterna.clamp(35.0, forzandoEstres.value ? 95.0 : 90.0);
      sensor.velocidadAire = sensor.velocidadAire.clamp(0.5, 3.0);

      _actualizarFirebase(sensor);
    }

    galpones.refresh();
  }

  String obtenerHoraGeneracion(Box box) {
    DateTime? primeraHora;

    for (var lista in box.values) {
      if (lista is List && lista.isNotEmpty) {
        final primerRegistro = lista.first;
        final horaStr = primerRegistro['hora'];
        if (horaStr is String) {
          final hora = DateTime.tryParse(horaStr);
          if (hora != null) {
            if (primeraHora == null || hora.isBefore(primeraHora)) {
              primeraHora = hora;
            }
          }
        }
      }
    }

    if (primeraHora == null) return "Sin datos";

    final ahora = DateTime.now();
    final esHoy = primeraHora.year == ahora.year &&
        primeraHora.month == ahora.month &&
        primeraHora.day == ahora.day;

    final horaFormateada =
        "${primeraHora.hour.toString().padLeft(2, '0')}:${primeraHora.minute.toString().padLeft(2, '0')}";

    return esHoy
        ? "Hoy $horaFormateada"
        : "${primeraHora.day}/${primeraHora.month} $horaFormateada";
  }

  double calcularPromedioConfianza(Box box) {
    double suma = 0;
    int total = 0;

    for (var lista in box.values) {
      // Cada lista es el array de un galpón
      if (lista is List) {
        for (var registro in lista) {
          // Cada registro es un Map<String,dynamic>
          final conf = registro['confianza'];
          if (conf is num) {
            suma += conf.toDouble();
            total++;
          }
        }
      }
    }
    return total == 0 ? 0.0 : suma / total;
  }
}
