

import 'package:chick_stell_view/services/auth_service.dart';
import 'package:chick_stell_view/views/login/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController {

  final AuthService _authService = AuthService();
  var isloading = false.obs;
  Rxn<User> user = Rxn<User>();

final storage = GetStorage();

  Future<void> register(String email, String password, String confirmPassword) async {
    isloading.value = true;
    try {
      isloading.value = true;
      User? newUser = await _authService.registerEmail(
      email,
      password,
      confirmPassword
      );

       if(newUser != null){
        user.value = newUser;
        await saveUserStorage(email, password);
        Get.offAll(() => HomePage());
       } else {
        Get.snackbar('Error', 'Error al registrarse');
       } 
      } catch (e) {

        Get.snackbar('Error', 'Error durante el registro: $e');
    }
  }

  Future<void> login(String email, String password) async {
    isloading.value = true;
    try {
      User? newUser = await _authService.loginEmail(
        email,
        password
        );
          if (newUser != null) {
            user.value = newUser;
            await saveUserStorage(email, password);
            Get.offAll(() => HomePage());
          } else {
            Get.snackbar('Error', 'Error al iniciar sesion');
          }
        } catch (e) {
            Get.snackbar('Error', 'Error durante el inicio de sesion');
        } finally {
            isloading.value = false;
    }
  }


  Future<void> saveUserStorage(String email, String password) async {
  await storage.write('email', email);
  await storage.write('password', password);

  }


}