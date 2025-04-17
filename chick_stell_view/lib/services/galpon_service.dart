import 'package:chick_stell_view/models/galpon_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GalponService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference galponesRef =
      FirebaseFirestore.instance.collection('galpones');

  Future<List<Map<String, dynamic>>> getGalpones() async {
    List<Map<String, dynamic>> galpones = [];

    QuerySnapshot queryGalpones = await galponesRef.get();

    queryGalpones.docs.forEach((doc) {
      galpones.add(doc.data() as Map<String, dynamic>);
    });

    return galpones;
  }

  Future<void> addGalpon(Galpon galpon) async {
    final docRef =
        firestore.collection('galpones').doc(); // genera doc con ID único
    final id = docRef.id;

    final galponConId = galpon.copyWith(id: id); // copia el galpon con ese id

    await docRef.set(galponConId.toJson()); // guarda el galpon con id propio
  }

  Future<void> updateGalpon(
      String galponId, Map<String, dynamic> galponData) async {
    try {
      await galponesRef.doc(galponId).update(galponData);
      print('Galpón actualizado correctamente.');
    } catch (e) {
      print('Error al actualizar el galpón: $e');
      throw Exception('No se pudo actualizar el galpón.');
    }
  }

  Future<void> deleteGalpon(String galponId) async {
    try {
      await galponesRef.doc(galponId).delete();
      print('Galpón eliminado correctamente.');
    } catch (e) {
      print('Error al eliminar el galpón: $e');
      throw Exception('No se pudo eliminar el galpón.');
    }
  }
}
