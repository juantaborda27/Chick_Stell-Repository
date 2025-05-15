import 'package:chick_stell_view/controllers/auth_controller.dart';
import 'package:chick_stell_view/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final AuthController authController = Get.put(AuthController());
  final StorageService storageService = Get.put(StorageService());

  final RxString email = ''.obs;
  final RxString password = ''.obs;
  final role = 'Administrador'.obs;
  final RxString name = ''.obs;
  final RxString phone = ''.obs;
  final RxString whatsapp = ''.obs;
  final Rx<XFile?> profileImage = Rx<XFile?>(null);

  @override
  void onInit(){
    super.onInit();
    loadUser();
  }

  Future<void> loadUser() async {
  email.value = authController.user.value?.email ?? '';

  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(authController.user.value?.uid)
      .get();

  if (doc.exists) {
    name.value = doc.data()?['name'] ?? '';
    phone.value = doc.data()?['phone'] ?? '';
    whatsapp.value = doc.data()?['whatsapp'] ?? '';
    role.value = doc.data()?['role'] ?? 'Administrador';
    
    // Cargar imagen si existe
    if (doc.data()?['imageUrl'] != null) {
      // Puedes almacenar la URL o manejarla directamente en la vista
    }
  }
}

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImage.value = image;
    }
  }

  Future<void> updateProfile() async {
    try {
        String? imageUrl;
        if (profileImage.value != null) {
          final storageService = Get.put(StorageService());
          imageUrl = await storageService.uploadProfileImage(authController.user.value!.uid, 
          profileImage.value!
          );
        }

        // Actualizar datos en Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(authController.user.value?.uid)
        .set({
          'name': name.value,
          'phone': phone.value,
          'whatsapp': whatsapp.value,
          'email': email.value,
          'role': role.value,
          if (imageUrl != null) 'imageUrl': imageUrl,
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

    Get.snackbar('Éxito', 'Perfil actualizado correctamente');
    Get.back(); // Cierra el modal de edición
    } catch (e) {
      Get.snackbar('Error', 'No se pudo actualizar el perfil: ${e.toString()}');

    } 
  }



  
}