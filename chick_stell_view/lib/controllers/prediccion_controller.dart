// lib/controllers/prediccion_controller.dart

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PrediccionController extends GetxController {
  RxString nivelEstres = "".obs;
  RxDouble confianza = 0.0.obs;
  RxString mensaje = "".obs;

  final _firestore = FirebaseFirestore.instance;
  late final Stream<QuerySnapshot> _stream;

  @override
  void onInit() {
    super.onInit();
    _stream = _firestore.collection('datos_sensores').orderBy('timestamp', descending: true).limit(1).snapshots();
    _stream.listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data() as Map<String, dynamic>;

        final cuerpo = {
          "timestamp": data["timestamp"],
          "temperatura_ambiente": data["temperatura_ambiente"],
          "humedad_relativa": data["humedad_relativa"],
          "velocidad_viento": data["velocidad_viento"],
          "temperatura_interior": data["temperatura_interior"],
          "humedad_interior": data["humedad_interior"],
          "cantidad_pollos": 5000
        };

        hacerPrediccion(cuerpo);
      }
    });
  }

  Future<void> hacerPrediccion(Map<String, dynamic> datos) async {
    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:8000/predecir"), // cambia por tu IP local o del servidor
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(datos),
      );

      if (response.statusCode == 200) {
        final resultado = jsonDecode(response.body);
        final niveles = ["Bajo", "Moderado", "Alto"];

        nivelEstres.value = niveles[resultado["prediccion"]];
        confianza.value = resultado["confianza"];
        mensaje.value = resultado["mensaje"];
      } else {
        mensaje.value = "Error en la predicción";
      }
    } catch (e) {
      mensaje.value = "No se pudo conectar al microservicio";
    }
  }
}
