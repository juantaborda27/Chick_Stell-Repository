import 'dart:io';

import 'package:chick_stell_view/controllers/auth_controller.dart';
import 'package:chick_stell_view/services/local_image_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final AuthController authController = Get.put(AuthController());
  final LocalImageService localImageService = LocalImageService();
  
  final RxString email = ''.obs;
  final RxString name = ''.obs;
  final RxString phone = ''.obs;
  final RxString whatsapp = ''.obs;
  final RxString localImagePath = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    loadLocalProfileImage();
  }

  Future<void> loadLocalProfileImage() async {
    final path = await localImageService.getProfileImagePath();
    if (path != null) {
      localImagePath.value = path;
    }
  }

  Future<void> pickImage() async {
        try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85, // Calidad reducida para ahorrar espacio
      );
      
      if (image != null) {
        final path = await localImageService.saveProfileImage(image);
        localImagePath.value = path!;
        Get.snackbar('Éxito', 'Imagen guardada correctamente');
      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudo guardar la imagen: ${e.toString()}');
      print('Error detallado: $e'); // Para depuración
    }

  }

  Future<void> updateProfile({
  String? newName,
  String? newPhone,
  String? newWhatsapp,
  File? newImageFile, // imagen opcional que subes
}) async {
  try {
    final uid = authController.user.value?.uid;
    if (uid == null) {
      Get.snackbar('Error', 'Usuario no autenticado');
      return;
    }

    final Map<String, dynamic> updateData = {};

    // Verifica y agrega cambios de texto
    if (newName != null && newName.isNotEmpty && newName != name.value) {
      updateData['name'] = newName;
      name.value = newName;
    }

    if (newPhone != null && newPhone != phone.value) {
      updateData['phone'] = newPhone;
      phone.value = newPhone;
    }

    if (newWhatsapp != null && newWhatsapp != whatsapp.value) {
      updateData['whatsapp'] = newWhatsapp;
      whatsapp.value = newWhatsapp;
    }

    // Subida de imagen a Firebase Storage si hay nueva imagen
    if (newImageFile != null) {
      final ref = FirebaseStorage.instance.ref().child('profile_images').child('$uid.jpg');
      await ref.putFile(newImageFile);
      final imageUrl = await ref.getDownloadURL();
      updateData['profileImage'] = imageUrl;
      //profileImageUrl.value = imageUrl; // si usas un observable
    }

    // Si hay cambios, actualiza en Firestore
    if (updateData.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(updateData, SetOptions(merge: true));

      Get.snackbar('Éxito', 'Perfil actualizado correctamente');
    } else {
      Get.snackbar('Sin cambios', 'No se detectaron cambios para guardar');
    }

    Get.back(); // cerrar modal o pantalla
  } catch (e) {
    Get.snackbar('Error', 'No se pudo actualizar el perfil: ${e.toString()}');
  }
}


  
}