import 'package:get/get.dart';

class AlertaController extends GetxController {
  final mostrarAlerta = false.obs;
  String titulo = '';
  String mensaje = '';

  void mostrar(String t, String m) {
    titulo = t;
    mensaje = m;
    mostrarAlerta.value = true;

    Future.delayed(const Duration(seconds: 8), () {
      mostrarAlerta.value = false;
    });
  }
}
