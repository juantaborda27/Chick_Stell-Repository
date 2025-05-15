import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class StorageService extends GetxService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadProfileImage(String userId, XFile image) async {
    try {
      final ref = _storage.ref('profile_images/$userId/${DateTime.now().millisecondsSinceEpoch}');
      await ref.putFile(File(image.path));
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error al subir la imagen: $e');
    }
  }
}