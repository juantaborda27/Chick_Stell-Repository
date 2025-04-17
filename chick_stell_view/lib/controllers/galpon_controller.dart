import 'package:chick_stell_view/models/galpon_model.dart';
import 'package:chick_stell_view/services/galpon_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GalponController extends GetxController {
  var galpones = <Galpon>[].obs;
  final GalponService _galponService = GalponService();

  @override
  void onInit() {
    super.onInit();
    cargarGalpones();
  }

  void cargarGalpones() async {
    try {
      var resultado = await _galponService.getGalpones();
      galpones.assignAll(resultado);
    } catch (e) {
      Get.snackbar('Error', 'No se pudieron cargar los galpones');
    }
  }

  Future<void> agregarGalpon(Galpon galpon) async {
    try {
      await FirebaseFirestore.instance
          .collection('galpones')
          .doc(galpon.id)
          .set(galpon.toJson()); // le mandas el modelo completo
      cargarGalpones(); // Refresca la lista
      Get.snackbar('Éxito', 'Galpón agregado correctamente');
    } catch (e) {
      Get.snackbar('Error', 'No se pudo agregar el galpón');
    }
  }

  Future<void> actualizarGalpon(String id, Galpon galpon) async {
    try {
      await _galponService.updateGalpon(id, galpon.toJson());
      cargarGalpones();
      Get.snackbar('Éxito', 'Galpón actualizado correctamente');
    } catch (e) {
      Get.snackbar('Error', 'No se pudo actualizar el galpón');
    }
  }

  Future<void> eliminarGalpon(String id) async {
    try {
      await _galponService.deleteGalpon(id);
      cargarGalpones();
      Get.snackbar('Éxito', 'Galpón eliminado correctamente');
    } catch (e) {
      Get.snackbar('Error', 'No se pudo eliminar el galpón');
    }
  }
}
