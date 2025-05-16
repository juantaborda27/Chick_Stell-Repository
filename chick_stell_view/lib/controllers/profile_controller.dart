import 'package:chick_stell_view/controllers/auth_controller.dart';
import 'package:chick_stell_view/services/local_image_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final RxString profileImageUrl = ''.obs; // opcional, para mostrar imagen online

  @override
  void onInit() async {
    super.onInit();
    await loadUserData(); // <-- carga datos del usuario
    await loadLocalProfileImage();

  }

  Future<void> loadUserData() async {
  final uid = authController.user.value?.uid;
  if (uid == null) return;

  final doc = await FirebaseFirestore.instance
      .collection('usuarios')
      .doc(uid)
      .get();

  if (doc.exists) {
    final data = doc.data()!;
    name.value = data['name'] ?? '';
    phone.value = data['phone'] ?? '';
    whatsapp.value = data['whatsapp'] ?? '';
    email.value = authController.user.value?.email ?? '';
  }
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
        imageQuality: 85,
      );

      if (image != null) {
        final path = await localImageService.saveProfileImage(image);
        localImagePath.value = path!;
        Get.snackbar('Éxito', 'Imagen guardada correctamente');
      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudo guardar la imagen: ${e.toString()}');
      print('Error detallado: $e');
    }
  }

  Future<void> updateProfile({
  String? newName,
  String? newPhone,
  String? newWhatsapp,
}) async {
  try {
    final uid = authController.user.value?.uid;
    if (uid == null) {
      Get.snackbar('Error', 'Usuario no autenticado');
      return;
    }

    final Map<String, dynamic> updateData = {};

    if (newName != null && newName.isNotEmpty && newName != name.value) {
      updateData['name'] = newName;
      name.value = newName;
    }

    if (newPhone != null && newPhone.isNotEmpty && newPhone != phone.value) {
      updateData['phone'] = newPhone;
      phone.value = newPhone;
    }

    if (newWhatsapp != null && newWhatsapp.isNotEmpty && newWhatsapp != whatsapp.value) {
      updateData['whatsapp'] = newWhatsapp;
      whatsapp.value = newWhatsapp;
    }

    if (updateData.isEmpty) {
      Get.snackbar('Sin cambios', 'No se detectaron cambios para guardar');
      return; // Salir aquí y no continuar
    }

    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .set(updateData, SetOptions(merge: true));

    Get.back(); // Cerrar el modal solo si se guardó
    Get.snackbar('Éxito', 'Perfil actualizado correctamente');
    
  } catch (e) {
    Get.snackbar('Error', 'No se pudo actualizar el perfil: ${e.toString()}');
  }
}

// Metodo obtener datos del FireStore
 Future<void> loadProfileFromFirestore() async {
  final uid = authController.user.value?.uid;
  if (uid == null) return;

  final doc = await FirebaseFirestore.instance
      .collection('usuarios')
      .doc(uid)
      .get();

  if (doc.exists) {
    final data = doc.data()!;
    name.value = data['name'] ?? '';
    phone.value = data['phone'] ?? '';
    whatsapp.value = data['whatsapp'] ?? '';
    email.value = authController.user.value?.email ?? '';


    print('Perfil cargado correctamente');
  }
 }


}
