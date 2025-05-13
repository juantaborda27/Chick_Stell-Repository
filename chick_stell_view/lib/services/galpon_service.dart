import 'package:chick_stell_view/models/galpon_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GalponService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference galponesRef =
      FirebaseFirestore.instance.collection('galpones');

  Future<List<Galpon>> getGalpones() async {
    final snapshot = await firestore.collection('galpones').get();

    final galpones = snapshot.docs.map((e) {
      final data = e.data();
      data['id'] = e.id; // Esto asegura que el modelo tenga el ID del documento
      return Galpon.fromJson(data);
    }).toList();

    return galpones;
  }

  Future<void> addGalpon(Galpon galpon) async {
    final docRef =
        firestore.collection('galpones').doc(galpon.id); // usa tu ID generado
    await docRef.set(galpon.toJson());
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

  Future<void> addGalponConId(Galpon galpon) async {
    await galponesRef.doc(galpon.id).set(galpon.toJson());
  }

  Future<void> guardarPredicciones({
    required String idGalpon,
    required String nombreGalpon,
    required List<Map<String, dynamic>> predicciones,
  }) async {
    try {
      final now = DateTime.now().toIso8601String();

      // Crear documento del galpón si no existe o actualizar el nombre
      await firestore.collection('predicciones').doc(idGalpon).set(
        {
          'nombre': nombreGalpon,
        },
        SetOptions(merge: true),
      );
      print('Documento del galpón creado o actualizado correctamente.');

      // Guardar predicciones en subcolección historial
      await firestore
          .collection('predicciones')
          .doc(idGalpon)
          .collection('historial')
          .doc(now)
          .set({
        'fecha': now,
        'predicciones': predicciones,
      });
      print('Predicciones guardadas correctamente en el historial.');
    } catch (e) {
      print('Error al guardar las predicciones: $e');
      throw Exception('No se pudo guardar las predicciones.');
    }
  }
  
}
