import 'package:chick_stell_view/models/galpon_model.dart';
import 'package:chick_stell_view/services/galpon_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class GalponController extends GetxController {
  var galpones = <Galpon>[].obs;
  final GalponService _galponService = GalponService();

  @override
  void onInit() {
    super.onInit();
    cargarGalpones();
  }

  Future<void> cargarGalpones() async {
    try {
      var resultado = await _galponService.getGalpones();
      galpones.assignAll(resultado);
    } catch (e) {
      Get.snackbar('Error', 'No se pudieron cargar los galpones');
    }
  }

  Future<void> agregarGalpon(Galpon galpon) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('Usuario no autenticado');

    final docRef = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('galpones')
        .doc(galpon.id);

    await docRef.set(galpon.toJson());
  }

  Future<void> actualizarGalpon(String id, Galpon galpon) async {
    try {
      await _galponService.updateGalpon(id, galpon.toJson());
      await cargarGalpones();
      Get.snackbar('Éxito', 'Galpón actualizado correctamente');
    } catch (e) {
      Get.snackbar('Error', 'No se pudo actualizar el galpón');
    }
  }

  Future<void> eliminarGalpon(String id) async {
    try {
      await _galponService.deleteGalpon(id);
      await cargarGalpones();
      Get.snackbar('Éxito', 'Galpón eliminado correctamente');
    } catch (e) {
      Get.snackbar('Error', 'No se pudo eliminar el galpón');
    }
  }
}
