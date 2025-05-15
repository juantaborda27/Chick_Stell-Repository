import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalImageService {
  static const String _profileImageKey = 'user_profile_image_path';

  Future<String> saveProfileImage(XFile image) async {
    try {
      // Verificar permisos solo para móvil
      if (!kIsWeb && !await _requestPermissions()) {
        throw Exception('Permisos de almacenamiento denegados');
      }

      if (kIsWeb) {
        // Implementación para web
        final bytes = await image.readAsBytes();
        final base64Image = base64Encode(bytes);
        final box = GetStorage();
        await box.write(_profileImageKey, base64Image);
        return 'web_image_${DateTime.now().millisecondsSinceEpoch}';
      } else {
        // Implementación para móvil/desktop
        final directory = await getApplicationDocumentsDirectory();
        final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final File localImage = File('${directory.path}/$fileName');

        await localImage.writeAsBytes(await image.readAsBytes());
        
        final box = GetStorage();
        await box.write(_profileImageKey, localImage.path);

        return localImage.path;
      }
    } catch (e) {
      throw Exception('Error al guardar imagen: ${e.toString()}');
    }
  }

  Future<String?> getProfileImagePath() async {
    final box = GetStorage();
    if (kIsWeb) {
      return box.read<String>(_profileImageKey);
    }
    return box.read<String>(_profileImageKey);
  }

  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final status = await Permission.storage.status;
      if (!status.isGranted) {
        final result = await Permission.storage.request();
        return result.isGranted;
      }
      return true;
    }
    return true; // Para web/desktop
  }
}