

import 'package:chick_stell_view/models/profile.dart';
import 'package:get/get.dart';
import 'package:chick_stell_view/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  var usuario = Rxn<Profile>();

  Future<bool> login(String email, String password) async {
    final perfil = await _authService.login(email, password);
    if (perfil != null) {
      usuario.value = perfil;
      return true;
    }
    return false;
  }

  void logout() {
    usuario.value = null;
  }
}
